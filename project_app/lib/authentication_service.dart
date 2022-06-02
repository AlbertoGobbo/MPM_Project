import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Sign In";
    } on FirebaseAuthException catch (e) {
      String message = e.code;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong user privded for that user';
      }
      print(message);
      return message;
    }
  }

  Future<String?> signUp(String email, String password, String username) async {
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? idUser = cred.user?.tenantId;

      // Add a new document with a generated ID
      FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .set({email: email, password: password, username: username});
      return "Sign Up";
    } on FirebaseAuthException catch (e) {
      String message = e.code;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong user privded for that user';
      }
      print(message);
      return message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
