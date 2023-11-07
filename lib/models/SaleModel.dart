class Sale {
  int? id;
  int customerId; // ID do cliente que fez a compra
  double totalPrice; // Preço total sem desconto
  DateTime saleDate;
  bool isCredit; // Campo para verificar se é "fiado"
  DateTime? paymentDate;
  DateTime? dueDate; // Campo de data de pagamento (fiado)

  Sale({
    this.id,
    required this.customerId,
    required this.totalPrice,
    required this.saleDate,
    required this.isCredit, // Adicionado campo para verificar se é "fiado"
    this.paymentDate,
    this.dueDate, // Adicionado campo de data de pagamento (fiado)
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'total_price': totalPrice, // Removido o campo 'totalPrice' dos produtos
      'sale_date': saleDate.toIso8601String(),
      'is_credit': isCredit, // Adicionado campo para verificar se é "fiado"
      'payment_date': paymentDate?.toIso8601String(),

      'due_date': dueDate
          ?.toIso8601String(), // Adicionado campo de data de pagamento (fiado)
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      customerId: map['customer_id'],
      totalPrice:
          0.0, // Definido como 0.0 porque o preço total agora é calculado nos itens
      saleDate: DateTime.parse(map['sale_date']),
      isCredit:
          map['is_credit'], // Adicionado campo para verificar se é "fiado"
      paymentDate: map['payment_date'] != null
          ? DateTime.parse(map['payment_date'])
          : null,
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'])
          : null, // Adicionado campo de data de pagamento (fiado)
    );
  }
}

class SaleItem {
  int? id; // ID do item de venda
  int saleId; // ID da venda à qual o item está associado
  int productId; // ID do produto vendido
  int quantity; // Quantidade vendida
  double itemPrice; // Preço do item
  double discountItemPrice; // Campo de desconto

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.itemPrice,
    required this.discountItemPrice, // Adicionado campo de desconto
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'quantity': quantity,
      'item_price': itemPrice,
      'discount_item_price': discountItemPrice, // Adicionado campo de desconto
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      itemPrice: map['item_price'],
      discountItemPrice: map['discount'], // Adicionado campo de desconto
    );
  }
}
