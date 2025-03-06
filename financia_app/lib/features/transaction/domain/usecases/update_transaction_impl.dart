import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'update_transaction.dart';

class UpdateTransactionImpl implements UpdateTransaction {
  final TransactionRepository transactionRepository;

  UpdateTransactionImpl({required this.transactionRepository});

  @override
  Future<TransactionEntity> call(
      String id, Map<String, dynamic> updatedData, String token) async {
    return await transactionRepository.updateTransaction(
        id, updatedData, token);
  }
}
