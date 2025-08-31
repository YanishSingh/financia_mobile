import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetEntity>> getBudgets(String token);
  Future<BudgetEntity> createBudget(
      Map<String, dynamic> budgetData, String token);
  Future<BudgetEntity> updateBudget(
      String id, Map<String, dynamic> budgetData, String token);
  Future<void> deleteBudget(String id, String token);
}
