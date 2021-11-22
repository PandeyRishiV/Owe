import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:owe/models/ContactInfo.dart';
import 'package:owe/pages/chatScreen.dart';
import 'package:owe/service/database_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Widget _body = Scaffold();
  Widget _progressBar = Scaffold();
  bool _bodyLoaded = false;

  @override
  void initState() {
    super.initState();
    areThereContacts();
  }

  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;
    Color _accent = Theme.of(context).accentColor;

    _progressBar = Center(
      child: CircularProgressIndicator(
        color: _primaryDark,
        backgroundColor: _primary,
      ),
    );

    return _bodyLoaded ? _body : _progressBar;
  }

  void areThereContacts() {
    [Permission.contacts].request().then((value) {
      ContactsService.getContacts(withThumbnails: false).then((value) async {
        if (value.isEmpty) {
          _body = emptyPage();
        } else {
          List<ContactInfo> contacts = [];
          value.toList().removeWhere((element) =>
              element.phones == null ||
              element.phones!.isEmpty ||
              element.displayName!.isEmpty);
          value.forEach((contact) {
            contact.phones!.forEach((phone) {
              ContactInfo newContact = new ContactInfo(
                  contact.displayName.toString(), phone.value.toString(), "");
              contacts.add(newContact);
            });
          });

          _body = contactPage(await DatabaseService()
                  .isContactRegistered(Stream.fromIterable(contacts))
              as List<ContactInfo>);
        }
        setState(() {
          _bodyLoaded = true;
        });
      });
    });
  }

  Widget emptyPage() {
    return Column(
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
  }

  Widget contactPage(List<ContactInfo> contacts) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(
              Icons.person_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              contacts.elementAt(index).name,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              contacts.elementAt(index).phone,
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(user: contacts.elementAt(index))));
            },
          );
        });
  }
}
