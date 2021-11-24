import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:owe/models/Chat.dart';
import 'package:owe/models/ContactInfo.dart';

List<ContactInfo> usersContacts = [];

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
  Future<bool> isContactRegistered(Stream<ContactInfo> allContacts) async {
    List<ContactInfo> registered = [];
    List<String> uids = [];
    try {
      DataSnapshot contactsListSnapshot =
          await _databaseReference.child('users').once();
      await for (ContactInfo contact in allContacts) {
        if (contactsListSnapshot.value[contact.phone] != null &&
            !uids.contains(contactsListSnapshot.value[contact.phone].values
                .toList()[0]['uid'])) {
          String uid = contactsListSnapshot.value[contact.phone].values
              .toList()[0]['uid'];
          uids.add(uid);
          contact.uid = uid;
          registered.add(contact);
        }
      }
      usersContacts = registered;
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Get chat list
  Future<List<ContactInfo>> getConversationList(String uid) async {
    List<String> uids = [];
    try {
      DataSnapshot contactsUid =
          await _databaseReference.child("conversation").child(uid).once();
      contactsUid.value.forEach((key, value) {
        uids.add(key.toString());
      });
      List<ContactInfo> recordContacts =
          usersContacts.where((contact) => uids.contains(contact.uid)).toList();
      return recordContacts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Get one chat
  Future<List<Chat>> getConversation(String uid, String recipuentUid) async {
    try {
      List<Chat> chats = [];
      DataSnapshot chatsSnapshot = await _databaseReference
          .child("conversation")
          .child(uid)
          .child(recipuentUid)
          .orderByValue()
          .once();
      chatsSnapshot.value.forEach((key, value) {
        Chat newText = new Chat(
            value['text'], DateTime.parse(value['timestamp']), value['sender']);
        chats.add(newText);
      });
      chats.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      chats = chats.reversed.toList();
      log(chats.length.toString());
      return chats;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Send text
  Future<bool> sendText(
      String text, String uid, String recipientUid, String timeStamp) async {
    try {
      await _databaseReference
          .child('conversation')
          .child(uid)
          .child(recipientUid)
          .push()
          .set({"text": text, "timestamp": timeStamp, "sender": true});
      await _databaseReference
          .child("conversation")
          .child(recipientUid)
          .child(uid)
          .push()
          .set({"text": text, "timestamp": timeStamp, "sender": false});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
