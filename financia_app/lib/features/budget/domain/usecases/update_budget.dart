import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class UpdateBudget {
  final BudgetRepository repository;

  UpdateBudget(this.repository);

  Future<BudgetEntity> call(
      String id, Map<String, dynamic> budgetData, String token) async {
    return await repository.updateBudget(id, budgetData, token);
  }
}
