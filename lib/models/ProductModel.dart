extension ProductModelExtension on ProductModel {
  // Getter para quantityInSale
  int get quantityInSale => _quantityInSale;

  // Setter para quantityInSale
  set quantityInSale(int value) {
    if (value >= 0) {
      // Modifica apenas _quantityInSale, sem afetar quantity
      _quantityInSale = value;
    } else {
      // Impede valores negativos
      _quantityInSale = 0;
    }
  }
}

class ProductModel {
  int _quantityInSale = 0;

  int id;
  String name;
  String? description;
  double price;
  int? categoryId;
  String? categoryName; // Nome da categoria
  int quantity;
  int? supplierId;
  String? supplierName; // Nome do fornecedor

  ProductModel({
    required this.id, // Tornar o ID opcional
    required this.name,
    this.description,
    required this.price,
    this.categoryId, // Tornar o categoryID opcional
    this.categoryName, // Tornar o categoryName opcional
    required this.quantity,
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
      'quantity': quantity, // Mantenha quantity como está
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
      quantity: map['quantity'],
      supplierId: map['supplier_id'],
      supplierName: map['supplier_name'],
    );
  }

  factory ProductModel.fromMapWithoutQuantity(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      quantity: 0,
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
    int? quantity,
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
      quantity: quantity ?? this.quantity,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
    );
  }
}
