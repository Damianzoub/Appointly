class UserProfile {
  final String uid;
  final String firstname;
  final String lastname;
  final String email;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  // Αντικατάσταση του fromFirestore με fromMap
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['id'] ?? '', // Στη Supabase συνήθως η στήλη λέγεται 'id'
      firstname: data['first_name'] ?? '',
      lastname: data['last_name'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: data['date_of_birth'] != null
          ? DateTime.parse(data['date_of_birth'])
          : null,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  // Αντικατάσταση του toFirestore με toMap
  Map<String, dynamic> toMap() {
    return {
      // Το 'id' συνήθως δημιουργείται αυτόματα από τη βάση (UUID)
      "email": email,
      "first_name": firstname,
      "last_name": lastname,
      "date_of_birth": dateOfBirth?.toIso8601String(),
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
