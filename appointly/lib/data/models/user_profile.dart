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
    required this.updatedAt,
  });

  // Αντικατάσταση του fromFirestore με fromMap
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['id'] ?? '', // Στη Supabase συνήθως η στήλη λέγεται 'id'
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: data['date_of_birth'] != null
          ? DateTime.parse(data['date_of_birth'])
          : null,
      phoneNumber: data['phone_number'] ?? '',
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  // Αντικατάσταση του toFirestore με toMap
  Map<String, dynamic> toMap() {
    return {
      // Το 'id' συνήθως δημιουργείται αυτόματα από τη βάση (UUID)
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "date_of_birth": dateOfBirth?.toIso8601String(),
      "phone_number": phoneNumber,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
