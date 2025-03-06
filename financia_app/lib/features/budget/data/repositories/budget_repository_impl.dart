import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_remote_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BudgetEntity>> getBudgets(String token) async {
    return await remoteDataSource.fetchBudgets(token);
  }

  @override
  Future<BudgetEntity> createBudget(
      Map<String, dynamic> budgetData, String token) async {
    return await remoteDataSource.createBudget(budgetData, token);
  }

  @override
  Future<BudgetEntity> updateBudget(
      String id, Map<String, dynamic> budgetData, String token) async {
    return await remoteDataSource.updateBudget(id, budgetData, token);
  }

  @override
  Future<void> deleteBudget(String id, String token) async {
    return await remoteDataSource.deleteBudget(id, token);
  }
}
