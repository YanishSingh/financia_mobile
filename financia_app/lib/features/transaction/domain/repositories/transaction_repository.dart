import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<TransactionEntity> addTransaction(
      Map<String, dynamic> data, String token);
  Future<List<TransactionEntity>> getTransactions(String token);
  Future<TransactionEntity> updateTransaction(
      String id, Map<String, dynamic> updatedData, String token);
  Future<void> deleteTransaction(String id, String token);
  Future<Map<int, double>> getMonthlySummary(int month, int year, String token);
}
