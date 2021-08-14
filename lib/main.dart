import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:owe/pages/home.dart';
import 'package:owe/pages/login.dart';
import 'package:owe/pages/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Variables
  final Brightness brightness = Brightness.light;
  final Color primary = Color.fromRGBO(175, 179, 190, 1);
  final Color primaryDark = Color.fromRGBO(3, 3, 3, 1);
  final Color accent = Colors.white;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Owe',
      home: Login(),
      theme: ThemeData(
        //Colors
        brightness: Brightness.light,
        primaryColor: primary,
        primaryColorDark: primaryDark,
        accentColor: accent,

        //Text Style
        textTheme: TextTheme(bodyText2: TextStyle(color: primaryDark)),

        //Text Field
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: primaryDark),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryDark)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryDark)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryDark))),

        iconTheme: IconThemeData(color: primaryDark),

        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(primaryDark),
          foregroundColor: MaterialStateProperty.all<Color>(primary),
        )),
      ),
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => Login(),
        "/register": (BuildContext context) => Register(),
        "/home": (BuildContext context) => Home()
      },
    );
  }
}
