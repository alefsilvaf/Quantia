class ProductCategory {
  int id;
  String name;
  String description;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
