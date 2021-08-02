import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:owe/pages/contacts.dart';
import 'package:owe/pages/records.dart';
import 'package:owe/service/auth_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;
    Color _accent = Theme.of(context).accentColor;

    Widget _contactUsBody = CircularProgressIndicator(
        color: _primaryDark, backgroundColor: _primary);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Background Color
        backgroundColor: _accent,

        //App Bar
        appBar: AppBar(
          //Three Dot Icon
          actionsIconTheme: IconThemeData(color: _primaryDark),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: dotMenuHandler,
                itemBuilder: (BuildContext context) {
                  return {'Logout'}.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
          ],

          //Toolbar Modifications
          toolbarHeight: 120,
          backgroundColor: _primary,

          //Title
          title: Text(
            "Owe",
            style: TextStyle(color: _primaryDark),
          ),

          //Tabs
          bottom: TabBar(
            labelColor: _accent,
            unselectedLabelColor: _primaryDark,
            tabs: [
              Tab(
                text: "Records",
              ),
              Tab(
                text: "Contacts",
              ),
            ],
          ),
        ),

        //Body for records and contacts
        body: TabBarView(
          children: [
            //Records Body
            Records(),

            // Contacts Body
            Contacts(),
          ],
        ),

        //floatingActionButton: Container(padding: EdgeInsets.fromLTRB(0, 0, 20, 40),child: FloatingActionButton(backgroundColor: _primary,onPressed: () {}, child: Icon(Icons.add,color: _primaryDark,),),),
      ),
    );
  }

  Future<void> dotMenuHandler(String value) async {
    switch (value) {
      case 'Logout':
        bool result = await AuthService().signoutUser();
        if (result) {
          Navigator.popAndPushNamed(context, "/login");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Some Error occured, Try Again",
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
    }
  }
}
