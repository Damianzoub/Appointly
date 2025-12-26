import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String firstname;
  final String lastname;
  final String email;
  final DateTime? dateOfBirth;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.dateOfBirth,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: data['date_of_birth'] != null
          ? (data['date_of_birth'] as Timestamp).toDate()
          : null,
      phoneNumber: data['phone_number'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate()
    );
  }

  Map<String,dynamic> toFirestore(){
    return {
      "email":email,
      "firstname":firstname,
      "lastname":lastname,
      "date_of_birth":dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      "phone_number":phoneNumber,
      "created_at":Timestamp.fromDate(createdAt),
      "updated_at":Timestamp.fromDate(updatedAt),
    };
  }
}