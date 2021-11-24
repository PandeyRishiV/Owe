import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Register
  Future<bool> signUpUser(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential).whenComplete(() {
        DatabaseService().registerContact(
            auth.currentUser!.phoneNumber.toString(), auth.currentUser!.uid);
        log("================================>" + auth.currentUser!.toString());
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //SignIn
  Future<bool> loginUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //SignOut
  Future<bool> signoutUser() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
