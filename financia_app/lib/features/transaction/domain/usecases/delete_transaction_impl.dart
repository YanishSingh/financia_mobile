import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'delete_transaction.dart';

class DeleteTransactionImpl implements DeleteTransaction {
  final TransactionRepository transactionRepository;

  DeleteTransactionImpl({required this.transactionRepository});

  @override
  Future<void> call(String id, String token) async {
    await transactionRepository.deleteTransaction(id, token);
  }
}
