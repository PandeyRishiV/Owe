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

  //Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  //Password Icons
  Icon _eyeState = Icon(Icons.visibility_off);
  bool _visible = false;

  //Error message check
  bool _validateEmail = true;
  bool _validatePassword = true;
  bool _validatePhone = true;

  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;

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

        //Email Text Field
        TextField(
          controller: _emailController,
          cursorColor: _primaryDark,
          textInputAction: TextInputAction.next,

          //Text Field Styling
          decoration: InputDecoration(
            labelText: "Email Address",
          ),
        ),

        SizedBox(
          height: 12.0,
        ),

        //Password Text Field
        TextField(
          controller: _passwordController,
          cursorColor: _primaryDark,
          textInputAction: TextInputAction.next,
          obscureText: !_visible,

          //Text Field Styling
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: _eyeState,
              color: _primaryDark,
              onPressed: () {
                visibilityChange();
              },
            ),
            labelText: "Password",
          ),
        ),

        SizedBox(
          height: 12.0,
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
                _emailController.clear();
                _passwordController.clear();
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

        SizedBox(
          height: 120,
        ),

        //Back to login screen
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
          child: Text(
            "Already have an account",
            style: TextStyle(color: _primaryDark),
          ),
        )
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

  void visibilityChange() {
    setState(() {
      if (_visible) {
        _eyeState = Icon(Icons.visibility_off);
        _visible = false;
      } else {
        _eyeState = Icon(Icons.visibility);
        _visible = true;
      }
    });
  }

  bool validateFields() {
    setState(() {
      //Checking and setting error texts if necessary
      _emailController.text.isNotEmpty
          ? _validateEmail = true
          : _validatePassword = false;
      _passwordController.text.isNotEmpty
          ? _validatePassword = true
          : _validatePassword = false;
      _phoneController.text.isNotEmpty
          ? _validatePhone = true
          : _validatePhone = false;
    });

    return _validateEmail &&
        _validatePassword &&
        _validatePhone &&
        _phoneController.text.length == 10;
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
    bool isRegistered = await AuthService()
        .registerUser(_emailController.text, _verificationID, otp);

    isRegistered
        ? Navigator.pushReplacementNamed(context, "/home")
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong, Please try again")));
  }
}
