class Sale {
  int id;
  int customerId; // ID do cliente que fez a compra
  List<Map<String, dynamic>> products; // Lista de produtos vendidos
  double totalPrice;
  DateTime saleDate;

  Sale({
    required this.id,
    required this.customerId,
    required this.products,
    required this.totalPrice,
    required this.saleDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'products': products,
      'total_price': totalPrice,
      'sale_date': saleDate.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      customerId: map['customer_id'],
      products: List<Map<String, dynamic>>.from(map['products']),
      totalPrice: map['total_price'],
      saleDate: DateTime.parse(map['sale_date']),
    );
  }
}
