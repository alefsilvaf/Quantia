// ignore_for_file: file_names

class ProductModel {
  int id;
  String name;
  String description;
  double price;
  int categoryId; // ID da categoria à qual o produto pertence
  int supplierId; // ID do fornecedor que fornece o produto

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.supplierId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'supplier_id': supplierId,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      categoryId: map['category_id'],
      supplierId: map['supplier_id'],
    );
  }
}
