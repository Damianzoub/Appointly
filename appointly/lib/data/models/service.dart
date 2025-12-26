class Service {
  final String id;
  final String name;
  final String nameEl;
  final String nameEn;
  final int minDurationMin;
  final int maxDurationMin;
  final double baseCost;
  final double currency;

  Service({
    required this.id,
    required this.name,
    required this.nameEl,
    required this.nameEn,
    required this.minDurationMin,
    required this.maxDurationMin,
    required this.baseCost,
    required this.currency,
  });

  factory Service.fromFirestore(Map<String,dynamic> json,String id){
    return Service(
      id: id,
      name: json['name'] ?? '',
      nameEl: json['name_el'] ?? '',
      nameEn: json['name_en'] ?? '',
      minDurationMin: json['min_duration_min'] ?? 0,
      maxDurationMin: json['max_duration_min'] ?? 0,
      baseCost: (json['base_cost'] ?? 0).toDouble(),
      currency: (json['currency'] ?? 0).toDouble(),
    );
  }
}