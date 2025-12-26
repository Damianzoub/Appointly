
class Provider {
  final String ProviderID;
  final String name;
  final List<String> serviceIDs;
  final String? phone;
  final String? email;
  final String? location;
  final double? rating;
  final bool isActive;

  Provider({
    required this.ProviderID,
    required this.name,
    required this.serviceIDs,
    this.phone,
    this.email,
    this.location,
    this.rating,
    required this.isActive,
  });

  factory Provider.fromFirestore(Map<String, dynamic> json, String id) {
    return Provider(
      ProviderID: id,
      name: json['name'] ?? '',
      serviceIDs: List<String>.from(json['service_ids'] ?? []),
      phone: json['phone'],
      email: json['email'],
      location: json['location'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "service_ids": serviceIDs,
      "phone": phone,
      "email": email,
      "location": location,
      "rating": rating,
      "is_active": isActive,
    };
  }

}