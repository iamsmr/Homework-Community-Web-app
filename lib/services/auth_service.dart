import 'package:Homework_Communities/models/user.dart';
import 'package:Homework_Communities/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  String error;
  //Firebase instance

  FirebaseAuth _auth = FirebaseAuth.instance;

  //USER fromFirebase user;
  User _userFromFirebaseUser(FirebaseUser user, {String email}) {
    return user != null ? User(uid: user.uid, email: email) : null;
  }

  //Create user With email and password
  Future cteateUserwithEmailAndPassword(
      String email, String password, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      await DatabaseService().updateUserData(username, email, user.uid);
      return _userFromFirebaseUser(user, email: email);
    } catch (e) {
      print(e);
      error = e.message;
    }
  }

  //Signin with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user, email: email);
    } catch (e) {
      print(e);
      error = e.message;
    }
  }

  //sign OUT
  Future signOut() async {
    return await _auth.signOut();
  }

  //Strem for AUTH changes
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }
}
