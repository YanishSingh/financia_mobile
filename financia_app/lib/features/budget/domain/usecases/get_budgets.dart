import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class GetBudgets {
  final BudgetRepository repository;

  GetBudgets(this.repository);

  Future<List<BudgetEntity>> call(String token) async {
    return await repository.getBudgets(token);
  }
}
