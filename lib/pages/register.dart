import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:owe/service/auth_service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Variables
  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationID = "";
  String _otp = "";
  bool _registerBody = true;
  Color _primary = Colors.white;
  Color _primaryDark = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _primary = Theme.of(context).primaryColor;
    _primaryDark = Theme.of(context).primaryColorDark;
  }

  //Controllers
  final _phoneController = TextEditingController();

  //Error message check
  bool _validatePhone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //BG COLOR
      backgroundColor: _primary,

      //Register App Bar
      appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 90,
          titleSpacing: 30,

          //Title
          title: Text(
            'Register To Continue',
            style: TextStyle(fontSize: 18),
          )),

      //Body
      body: SafeArea(
        child: _registerBody ? registerPage(_primary, _primaryDark) : otpPage(),
      ),
    );
  }

  Widget registerPage(Color _primary, Color _primaryDark) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),

        //PhoneText Field
        TextField(
          controller: _phoneController,
          cursorColor: _primaryDark,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,

          //Text Field Styling
          decoration: InputDecoration(
            labelText: "Phone",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("* Verification code will be sent to this phone number"),

        SizedBox(
          height: 40.0,
        ),

        //Cancel and Next Buttons
        ButtonBar(
          children: <Widget>[
            //Cancel
            TextButton(
              onPressed: () {
                _phoneController.clear();
              },
              child: Text(
                'Clear',
                style: TextStyle(color: _primaryDark),
              ),
            ),

            //Next
            ElevatedButton(
                onPressed: () async {
                  //All necessary checks before registering to firebase
                  if (validateFields()) {
                    verifyPhone(_phoneController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid or missing credentials"),
                      ),
                    );
                  }
                },
                child: Text('Next')),
          ],
        ),
      ],
    );
  }

  Widget otpPage() {
    return ListView(
      padding: EdgeInsets.all(40),
      children: <Widget>[
        OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width / 2,
          fieldWidth: 15,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.underline,
          onCompleted: (otp) {
            _otp = otp;
          },
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () {
            if (_otp.toString().length == 6) {
              proceedToLogin(_otp);
            }
          },
          child: Text("Submit"),
        ),
      ],
    );
  }

  bool validateFields() {
    setState(() {
      //Checking and setting error texts if necessary
      _phoneController.text.isNotEmpty
          ? _validatePhone = true
          : _validatePhone = false;
    });

    return _validatePhone && _phoneController.text.length == 10;
  }

  Future<void> verifyPhone(String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: "+91 " + phone,
      //timeout: Duration(milliseconds: 10000),
      verificationCompleted: (PhoneAuthCredential credential) {
        print(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        print(verificationId + "===============" + resendToken.toString());
        setState(() {
          _verificationID = verificationId;
          _registerBody = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
    );
  }

  Future<void> proceedToLogin(String otp) async {
    bool isRegistered = await AuthService().signUpUser(_verificationID, otp);

    isRegistered
        ? Navigator.pushReplacementNamed(context, "/home")
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong, Please try again")));
  }
}
