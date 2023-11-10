class CapitalTransactionModel {
  int id;
  int transactionType;
  String description;
  double amount;
  String transactionDate;

  CapitalTransactionModel({
    required this.id,
    required this.transactionType,
    required this.description,
    required this.amount,
    required this.transactionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_type': transactionType,
      'description': description,
      'amount': amount,
      'transaction_date': transactionDate,
    };
  }

  factory CapitalTransactionModel.fromMap(Map<String, dynamic> map) {
    return CapitalTransactionModel(
      id: map['id'],
      transactionType: map['transaction_type'],
      description: map['description'],
      amount: map['amount'],
      transactionDate: map['transaction_date'],
    );
  }
}
