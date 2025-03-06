class TransactionEntity {
  final String id;
  final String user;
  final String type; // 'income' or 'expense'
  final String category;
  final double amount;
  final DateTime date;
  final String? description;

  TransactionEntity({
    required this.id,
    required this.user,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });
}
