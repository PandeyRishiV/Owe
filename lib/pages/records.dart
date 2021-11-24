import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owe/models/ContactInfo.dart';
import 'package:owe/service/database_service.dart';

import 'chatScreen.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  String _uid = FirebaseAuth.instance.currentUser!.uid;
  Widget _body = SizedBox();
  bool isBodyLoaded = false;
  Color _primary = Colors.white;
  Color _primaryDark = Colors.white;
  Color _accent = Colors.white;

  @override
  void initState() {
    super.initState();
    _getBody();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Locally imported colors
    _primary = Theme.of(context).primaryColor;
    _primaryDark = Theme.of(context).primaryColorDark;
    _accent = Theme.of(context).accentColor;
  }

  @override
  Widget build(BuildContext context) {
    Widget _progressBar = Center(
      child: CircularProgressIndicator(
        color: _primaryDark,
        backgroundColor: _primary,
      ),
    );

    return Container(
      child: SafeArea(
        child: isBodyLoaded ? _body : _progressBar,
      ),
    );
  }

  void _getBody() async {
    await DatabaseService().getConversationList(this._uid).then((uids) {
      if (uids.length > 0) {
        _body = _chatListBody(uids);
      } else {
        _body = _emptyBody();
      }
      setState(() {
        isBodyLoaded = true;
      });
    });
  }

  Widget _emptyBody() {
    return Column(
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
    );
  }

  Widget _chatListBody(List<ContactInfo> recordContacts) {
    return ListView.builder(
        itemCount: recordContacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(recordContacts.elementAt(index).name),
            subtitle: Text(recordContacts.elementAt(index).phone),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(user: recordContacts.elementAt(index))));
            },
          );
        });
  }
}
