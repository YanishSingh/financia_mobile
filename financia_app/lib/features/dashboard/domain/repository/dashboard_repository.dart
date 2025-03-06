// lib/features/dashboard/domain/repositories/dashboard_repository.dart
import '../entities/transaction.dart';

abstract class DashboardRepository {
  Future<List<TransactionEntity>> getTransactions(
      {required int month, required int year});
}
