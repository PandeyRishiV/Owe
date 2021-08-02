import 'package:flutter/material.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //No records found Banner
            Image.asset(
              "assets/empty_background_home.jpg",
              width: MediaQuery.of(context).size.width / 2,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "No payment records found",
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
