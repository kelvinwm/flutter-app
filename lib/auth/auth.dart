import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

class Auth {
  // TODO: USER LOGIN
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _fireBaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  // TODO: CREATE ACCOUNT
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _fireBaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  // TODO: CURRENT USER
  Future<String> currentUser() async {
    FirebaseUser user = await _fireBaseAuth.currentUser();
    return user.uid;
  }
  // TODO: SIGNOUT USER
  Future<void> signOut() async {
    return await _fireBaseAuth.signOut();
  }
}
