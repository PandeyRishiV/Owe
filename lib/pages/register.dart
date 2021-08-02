import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owe/service/auth_service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Variables
  //Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //Password Icons
  Icon _eyeState = Icon(Icons.visibility_off);
  Icon _eyeStateConfirm = Icon(Icons.visibility_off);

  //Error message check
  bool _visible = false;
  bool _visibleConfirm = false;
  bool _validateEmail = true;
  bool _validatePassword = true;
  bool _validateConfirmPassword = true;

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
          toolbarHeight: 150,
          titleSpacing: 30,
          backgroundColor: _primary,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: _primaryDark),

          //Title and Sub-title
          title: Text(
            'Register To Continue',
            style: TextStyle(color: _primaryDark, fontSize: 18),
          )),

      //Body
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),

            //Email Text Field
            TextField(
              controller: _emailController,
              cursorColor: _primaryDark,
              style: TextStyle(color: _primaryDark),

              //Text Field Styling
              decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(color: _primaryDark),
                  errorText:
                      _validateConfirmPassword ? null : "Enter email address"),
            ),

            SizedBox(
              height: 12.0,
            ),

            //Password Text Field
            TextField(
              controller: _passwordController,
              cursorColor: _primaryDark,
              style: TextStyle(color: _primaryDark),

              //Text Field Styling
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: _eyeState,
                    color: _primaryDark,
                    onPressed: () {
                      setState(() {
                        if (_visible) {
                          _eyeState = Icon(Icons.visibility_off);
                          _visible = false;
                        } else {
                          _eyeState = Icon(Icons.visibility);
                          _visible = true;
                        }
                      });
                    },
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(color: _primaryDark),
                  errorText:
                      _validateConfirmPassword ? null : "Enter password"),
              obscureText: !_visible,
            ),

            SizedBox(
              height: 12.0,
            ),

            //Confirm Password Text Field
            TextField(
              controller: _confirmPasswordController,
              cursorColor: _primary,
              style: TextStyle(color: _primaryDark),

              //Text Field Styling
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: _eyeStateConfirm,
                    color: _primaryDark,
                    onPressed: () {
                      setState(() {
                        if (_visibleConfirm) {
                          _eyeStateConfirm = Icon(Icons.visibility_off);
                          _visibleConfirm = false;
                        } else {
                          _eyeStateConfirm = Icon(Icons.visibility);
                          _visibleConfirm = true;
                        }
                      });
                    },
                  ),
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: _primaryDark),
                  errorText:
                      _validateConfirmPassword ? null : "Re-enter password"),
              obscureText: !_visibleConfirm,
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
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: _primaryDark),
                    )),

                //Next
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        //Checking and setting error texts if necessary
                        _emailController.text.isNotEmpty
                            ? _validateEmail = true
                            : _validatePassword = false;
                        _passwordController.text.isNotEmpty
                            ? _validatePassword = true
                            : _validatePassword = false;
                        _confirmPasswordController.text.isNotEmpty
                            ? _validateConfirmPassword = true
                            : _validateConfirmPassword = false;
                      });

                      //All necessary checks before resgistering to firebase
                      if (_validateEmail &&
                          _validatePassword &&
                          _validateConfirmPassword) {
                        bool isRegistered = await AuthService().registerUser(
                            _emailController.text, _passwordController.text);
                        isRegistered
                            ? Navigator.pushReplacementNamed(context, "/login")
                            : null;
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
                child: Text("Already have an account",
                    style: TextStyle(color: _primaryDark)))
          ],
        ),
      ),
    );
  }
}
