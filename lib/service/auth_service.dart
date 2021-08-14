import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Check Logged In User

  //Register
  Future<bool> registerUser(
      String email, String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential);
      //DatabaseService().createUser(auth.currentUser!.uid, email);
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
