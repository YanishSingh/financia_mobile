class BudgetEntity {
  final String id;
  final String user;
  final String category;
  final double totalBudget;
  final DateTime startDate;
  final DateTime endDate;

  BudgetEntity({
    required this.id,
    required this.user,
    required this.category,
    required this.totalBudget,
    required this.startDate,
    required this.endDate,
  });
}
