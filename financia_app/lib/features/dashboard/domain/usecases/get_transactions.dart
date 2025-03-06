// lib/features/dashboard/domain/usecases/get_transactions.dart
import '../entities/transaction.dart';
import '../repository/dashboard_repository.dart';

class GetTransactions {
  final DashboardRepository repository;

  GetTransactions(this.repository);

  Future<List<TransactionEntity>> execute(
      {required int month, required int year}) {
    return repository.getTransactions(month: month, year: year);
  }
}
