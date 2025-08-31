import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class CreateBudget {
  final BudgetRepository repository;

  CreateBudget(this.repository);

  Future<BudgetEntity> call(
      Map<String, dynamic> budgetData, String token) async {
    return await repository.createBudget(budgetData, token);
  }
}
