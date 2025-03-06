// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart
import '../../domain/entities/transaction.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../datasources/remote_dashboard_data_source.dart';
import '../models/transaction_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final RemoteDashboardDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions(
      {required int month, required int year}) async {
    final token = await Future.value(
        "your_jwt_token"); // Replace with actual token retrieval logic
    final rawTransactions = await remoteDataSource.fetchTransactions(token);
    // Convert raw transactions to models and filter by month/year.
    final transactions =
        rawTransactions.map((json) => TransactionModel.fromJson(json)).toList();
    return transactions
        .where((tx) => tx.date.month == month && tx.date.year == year)
        .toList();
  }
}
