import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Check Logged In User

  //Register
  Future<bool> registerUser(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //DatabaseService().createUser(auth.currentUser!.uid, email);
      print("--------------------------" + email + "-------------" + password);
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
