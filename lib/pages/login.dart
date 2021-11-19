import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:owe/service/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Variables
  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationID = "";
  String _intlCode = "+91";
  String _otp = "";
  bool _loginBody = true;

  //Controllers
  final _phoneController = TextEditingController();

  //Error message check
  bool _validatePhone = true;

  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;

    return Scaffold(
      //BG COLOR
      backgroundColor: _primary,

      //login App Bar
      appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 90,
          titleSpacing: 30,

          //Title
          title: Text(
            'login To Continue',
            style: TextStyle(fontSize: 18),
          )),

      //Body
      body: SafeArea(
        child: _loginBody ? loginPage(_primary, _primaryDark) : otpPage(),
      ),
    );
  }

  Widget loginPage(Color _primary, Color _primaryDark) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),

        IntlPhoneField(
          decoration: InputDecoration(
            labelText: "Phone Number",
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          controller: _phoneController,
          initialCountryCode: "IN",
          onCountryChanged: (code) {
            setState(() {
              _intlCode = code.countryCode.toString();
            });
          },
        ),

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
                  //All necessary checks before logging in to firebase
                  if (validateFields()) {
                    verifyPhone(_phoneController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid or missing credentials " + _otp),
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
      phoneNumber: _intlCode + phone,
      timeout: Duration(seconds: 60),
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
          _loginBody = false;
          FocusScope.of(context).nearestScope;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
    );
  }

  Future<void> proceedToLogin(String otp) async {
    bool isLoggedIn = await AuthService().signUpUser(_verificationID, otp);

    isLoggedIn
        ? Navigator.pushReplacementNamed(context, "/home")
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong, Please try again")));
  }
}
