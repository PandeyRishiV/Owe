import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Widget _body = Scaffold();
  bool _bodyLoaded = false;

  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;
    Color _accent = Theme.of(context).accentColor;

    _body = CircularProgressIndicator(
      color: _primaryDark,
      backgroundColor: _primary,
    );

    return Scaffold(
      body: areThereContacts() ? _body : _body,
    );
  }

  bool areThereContacts() {
    log("=======================");
    Iterable<Contact> contacts;
    ContactsService.getContacts().then((value) {
      contacts = value;
      if (contacts.isEmpty) {
        Widget emptyPage = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //No Contacts Banner
            Image.asset(
              "assets/empty_contact_list.jpg",
              width: MediaQuery.of(context).size.width / 2,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "No Contacts Found",
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
        _body = emptyPage;
        return true;
      }
    });
    return false;
  }
}
