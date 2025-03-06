import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'get_monthly_summary.dart';

class GetMonthlySummaryImpl implements GetMonthlySummary {
  final TransactionRepository transactionRepository;

  GetMonthlySummaryImpl({required this.transactionRepository});

  @override
  Future<Map<int, double>> call(int month, int year, String token) async {
    return await transactionRepository.getMonthlySummary(month, year, token);
  }
}
