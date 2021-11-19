import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  //Register User
  Future<bool> registerContact(String contact, String uid) async {
    try {
      _databaseReference.child('users').child(contact).set({"uid": uid});
      return true;
    } catch (e) {
      return false;
    }
  }

  //Check user contacts
  Future<List> getContacts(List<String> phones) async {
    try {
      return phones;
    } catch (e) {
      print(e.toString());
      return (phones);
    }
  }

  //Get chat list

  //Get one chat

  //Send text
}
