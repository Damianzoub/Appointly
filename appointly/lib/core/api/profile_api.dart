import 'package:cloud_firestore/cloud_firestore.dart'; // Αλλαγή σε Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'api_exceptions.dart';

class ProfileApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Δημιουργία Προφίλ στο Firestore
  Future<void> createProfile({
    required String userID,
    required String username,
    required String name,
    required String surname,
    DateTime? dob,
  }) async {
    try {
      await _db.collection("users").doc(userID).set({
        'username': username,
        'first_name': name,
        'last_name': surname,
        'dob': dob?.toIso8601String(),
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ApiException("Failed to create profile: $e");
    }
  }

  // Ενημέρωση Προφίλ
  Future<void> updateMyProfile({
    String? name,
    String? surname,
    String? username,
    String? email,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw ApiException("Not logged In");

    final patch = <String, dynamic>{};

    // Έλεγχος αν το username υπάρχει ήδη (Firestore query)
    if (username != null) {
      final query = await _db
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      // Αν βρεθεί άλλος χρήστης με αυτό το username
      if (query.docs.isNotEmpty && query.docs.first.id != uid) {
        throw ApiException("Username already exists");
      }
      patch['username'] = username;
    }

    if (name != null) patch['first_name'] = name;
    if (surname != null) patch['last_name'] = surname;
    if (email != null) patch['email'] = email;

    if (patch.isNotEmpty) {
      try {
        await _db.collection('users').doc(uid).update(patch);
      } catch (e) {
        throw ApiException("Failed to update Profile");
      }
    }
  }

  // Ανάγνωση Προφίλ
  Future<Map<String, dynamic>> getMyProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw ApiException("Not logged In");

    try {
      final doc = await _db.collection("users").doc(uid).get();
      if (!doc.exists) throw ApiException("Profile not found");
      return doc.data()!;
    } catch (e) {
      throw ApiException("Failed to load profile");
    }
  }

  // Διαγραφή Προφίλ
  Future<void> deleteMyProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw ApiException("Not logged in");

    try {
      // Διαγραφή από Firestore
      await _db.collection("users").doc(user.uid).delete();
      // Διαγραφή από Auth και Sign Out
      await user.delete();
    } catch (e) {
      throw ApiException("Failed to delete profile");
    }
  }
}
