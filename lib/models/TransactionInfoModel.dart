class TransactionInfo {
  final int? id;
  final String description;
  final double amount;
  final DateTime transactionDate;
  final int transactionType;

  TransactionInfo({
    this.id,
    required this.description,
    required this.amount,
    required this.transactionDate,
    required this.transactionType,
  });
}
