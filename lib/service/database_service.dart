import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:owe/models/ContactInfo.dart';

class DatabaseService {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  //Register User
  Future<bool> registerContact(String contact, String uid) async {
    try {
      _databaseReference
          .child('users')
          .child(contact)
          .push()
          .set({"uid": uid, "name": null});
      return true;
    } catch (e) {
      return false;
    }
  }

  //Check user's contacts (One at a time)
  Future<List> isContactRegistered(Stream<ContactInfo> allContacts) async {
    List<ContactInfo> registered = [];
    List<String> uids = [];
    try {
      DataSnapshot s = await _databaseReference.child('users').once();
      //TODO FIND A BETTER FUCKING WAY TO USE UIDS
      await for (ContactInfo contact in allContacts) {
        if (s.value[contact.phone] != null &&
            !uids.contains(s.value[contact.phone].values.toList()[0]['uid'])) {
          String uid = s.value[contact.phone].values.toList()[0]['uid'];
          uids.add(uid);
          contact.uid = uid;
          registered.add(contact);
        }
      }
      return registered;
    } catch (e) {
      print(e.toString());
      return registered;
    }
  }

  // <String> isContactRegistered(Stream<String> allContacts) async* {
  //   try {
  //     await for (final phone in allContacts) {
  //       DataSnapshot s =
  //           await _databaseReference.child('users').child(phone).once();
  //       if (s.value != null) {
  //         yield s.value.toString();
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  //Get chat list

  //Get one chat

  //Send text
}
