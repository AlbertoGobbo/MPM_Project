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
      return e.code;
    }
  }

  Future<String?> signUp(String email, String password, String username) async {
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? idUser = cred.user?.uid;

      Map<String, dynamic> user = {
        "email": email,
        "password": password,
        "username": username,
        "users_kcal": "2000",
      };

      FirebaseFirestore.instance.collection("users").doc(idUser).set(user);
      return "Sign Up";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
