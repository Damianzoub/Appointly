import 'package:firebase_auth/firebase_auth.dart'; // Αλλαγή σε Firebase
import 'api_exceptions.dart';

class AuthApi {
  // Χρήση του FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw ApiException(e.message ?? "Σφάλμα σύνδεσης");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> signUpAuthOnly({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw ApiException(e.message ?? "Σφάλμα εγγραφής");
    }
  }

  // Επιστρέφει το UID του χρήστη από το Firebase
  String? get currentUserID => _auth.currentUser?.uid;
  bool get isLoggedIn => _auth.currentUser != null;
}
