class Category {
  final String id;
  final String nameEl;
  final String nameEn;
  final String description;

  Category({
    required this.id,
    required this.nameEl,
    required this.nameEn,
    required this.description,
  });

  factory Category.fromFirestore(Map<String,dynamic> json, String id){
    return Category(id: id, nameEl: json['name_el'] ?? '', nameEn: json['name_en'] ?? '', description: json['description']);
  }

  Map<String,dynamic> toFirestore(){
    return {
      "nameEl": nameEl,
      "nameEn": nameEn,
      "description": description,
    };
  }
}