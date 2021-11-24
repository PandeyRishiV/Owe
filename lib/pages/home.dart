import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:owe/models/ContactInfo.dart';
import 'package:owe/pages/contacts.dart';
import 'package:owe/pages/records.dart';
import 'package:owe/service/auth_service.dart';
import 'package:owe/service/database_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color _primary = Colors.white;
  Color _primaryDark = Colors.white;
  Color _accent = Colors.white;

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _primary = Theme.of(context).primaryColor;
    _primaryDark = Theme.of(context).primaryColorDark;
    _accent = Theme.of(context).accentColor;
  }

  bool _contactsRecieved = false;

  @override
  Widget build(BuildContext context) {
    return _contactsRecieved ? _tabbedLayout() : _progressBar();
  }

  Widget _progressBar() {
    return Container(
      color: _accent,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: _primaryDark,
        backgroundColor: _primary,
      ),
    );
  }

  Widget _tabbedLayout() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Background Color
        backgroundColor: _accent,

        //App Bar
        appBar: AppBar(
          //Three Dot Icon
          actionsIconTheme: IconThemeData(
            color: _primaryDark,
          ),
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

  void dotMenuHandler(String value) async {
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
                style: TextStyle(color: _primaryDark),
              ),
              backgroundColor: _primary,
            ),
          );
        }
    }
  }

  void getAllContacts() {
    [Permission.contacts].request().then((value) {
      ContactsService.getContacts(withThumbnails: false).then((value) async {
        if (value.isEmpty) {
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

          bool result = await DatabaseService()
              .isContactRegistered(Stream.fromIterable(contacts));
          setState(() {
            _contactsRecieved = result;
          });
        }
      });
    });
  }
}
