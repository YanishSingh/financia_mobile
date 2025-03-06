// lib/features/dashboard/data/models/transaction_model.dart
import '../../domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.type,
    required super.category,
    required super.amount,
    required super.date,
    super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
