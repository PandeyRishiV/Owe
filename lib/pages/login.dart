import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owe/service/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Variables

  //Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Check Eye Icon status
  Icon _eyeState = Icon(Icons.visibility_off);
  bool _visible = false;

  //Validation
  bool _validateEmail = true;
  bool _validatePassword = true;

  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;

    //Login Page Layout
    return Scaffold(
      //Custom Background Color
      backgroundColor: _primary,

      //Login App Bar
      appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 90,
          titleSpacing: 30,

          //Title
          title: Text(
            'Login To Continue',
            style: TextStyle(fontSize: 18),
          )),

      //Body
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          //Spacing from Top
          SizedBox(
            height: 120.0,
          ),

          //Email Text Field
          TextField(
            controller: _emailController,
            cursorColor: _primaryDark,
            textInputAction: TextInputAction.next,
            //Text Field Styling
            decoration: InputDecoration(
              labelText: "Username or Email",
              errorText: _validateEmail ? null : "Enter email address",
            ),
          ),

          SizedBox(
            height: 12.0,
          ),

          //Password Text Field
          TextField(
            controller: _passwordController,
            cursorColor: _primaryDark,
            textInputAction: TextInputAction.done,
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
              errorText: _validatePassword ? null : "Enter password",
            ),
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
                  //Clear text fields
                  _emailController.clear();
                  _passwordController.clear();
                },
                child: Text(
                  'Clear',
                  style: TextStyle(color: _primaryDark),
                ),
              ),

              //Next
              ElevatedButton(
                onPressed: () async {
                  //Check if fields are not empty, go to home if login successful
                  if (checkFields()) {
                    bool isLoggedIn = await AuthService().loginUser(
                        _emailController.text, _passwordController.text);
                    isLoggedIn
                        ? Navigator.popAndPushNamed(context, "/home")
                        : null;
                  }
                },
                child: Text(
                  'Next',
                ),
              ),
            ],
          ),

          SizedBox(
            height: 120,
          ),

          //Forgot password and Register Buttons
          ButtonBar(
            alignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //Forgot Password
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: _primaryDark),
                  )),

              //Register
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/register");
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: _primaryDark),
                  )),
            ],
          )
        ],
      )),
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

  bool checkFields() {
    setState(() {
      _emailController.text.isNotEmpty
          ? _validateEmail = true
          : _validateEmail = false;
      _passwordController.text.isNotEmpty
          ? _validatePassword = true
          : _validatePassword = false;
    });

    return _validateEmail && _validatePassword;
  }
}
