class ProductModel {
  int id;
  String name;
  String description;
  double price;
  int? categoryId;
  String? categoryName; // Nome da categoria
  int? supplierId;
  String? supplierName; // Nome do fornecedor

  ProductModel({
    required this.id, // Tornar o ID opcional
    required this.name,
    required this.description,
    required this.price,
    this.categoryId, // Tornar o categoryID opcional
    this.categoryName, // Tornar o categoryName opcional
    this.supplierId, // Tornar o supplierID opcional
    this.supplierName, // Tornar o supplierName opcional
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (supplierId != null) 'supplier_id': supplierId,
      if (supplierName != null) 'supplier_name': supplierName,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      supplierId: map['supplier_id'],
      supplierName: map['supplier_name'],
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? categoryId,
    String? categoryName,
    int? supplierId,
    String? supplierName,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
    );
  }
}
