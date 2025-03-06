import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'get_transactions.dart';

class GetTransactionsImpl implements GetTransactions {
  final TransactionRepository transactionRepository;

  GetTransactionsImpl({required this.transactionRepository});

  @override
  Future<List<TransactionEntity>> call(String token) async {
    return await transactionRepository.getTransactions(token);
  }
}
