import 'package:contacts_service/contacts_service.dart';
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
      ContactsService.getContacts(withThumbnails: false).then((value) {
        if (value.isEmpty) {
          _body = emptyPage();
        } else {
          value.toList().removeWhere((element) =>
              element.androidAccountType != AndroidAccountType.google);
          _body = contactPage(value);
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

  Widget contactPage(Iterable<Contact> contacts) {
    return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              contacts.toList().elementAt(index).displayName.toString(),
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              // contacts
              //     .toList()
              //     .elementAt(index)
              //     .emails!
              //     .toList()
              //     .elementAt(0)
              //     .toString()
              test(contacts.toList().elementAt(index)),
              style: TextStyle(color: Colors.black),
            ),
          );
        });
  }

  String test(Contact contact) {
    Iterable<Item>? phone = contact.emails;
    if (phone!.toList().isNotEmpty) {
      return phone.toList().elementAt(0).value.toString();
    }
    return "null";
  }
}
