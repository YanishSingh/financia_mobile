import 'package:financia_app/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:financia_app/features/transaction/data/models/transaction_model.dart';
import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TransactionEntity> addTransaction(
      Map<String, dynamic> data, String token) async {
    final jsonResponse = await remoteDataSource.addTransaction(data, token);
    return TransactionModel.fromJson(jsonResponse);
  }

  @override
  Future<List<TransactionEntity>> getTransactions(String token) async {
    final jsonList = await remoteDataSource.getTransactions(token);
    return jsonList
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TransactionEntity> updateTransaction(
      String id, Map<String, dynamic> updatedData, String token) async {
    final jsonResponse =
        await remoteDataSource.updateTransaction(id, updatedData, token);
    return TransactionModel.fromJson(jsonResponse);
  }

  @override
  Future<void> deleteTransaction(String id, String token) async {
    await remoteDataSource.deleteTransaction(id, token);
  }

  @override
  Future<Map<int, double>> getMonthlySummary(
      int month, int year, String token) async {
    final response =
        await remoteDataSource.getMonthlySummary(month, year, token);
    // Convert keys from String to int.
    return response.map(
        (key, value) => MapEntry(int.parse(key), (value as num).toDouble()));
  }
}
