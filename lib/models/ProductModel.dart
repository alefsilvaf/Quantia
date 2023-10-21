class ProductModel {
  int id;
  String name;
  String description;
  double price;
  int categoryId;
  String categoryName; // Nome da categoria
  int supplierId;
  String supplierName; // Nome do fornecedor

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.supplierId,
    required this.supplierName, // Adicione o nome do fornecedor aqui
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'category_name': categoryName,
      'supplier_id': supplierId,
      'supplier_name': supplierName, // Inclua o nome do fornecedor no mapa
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
}
