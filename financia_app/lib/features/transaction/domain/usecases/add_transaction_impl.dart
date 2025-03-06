import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:financia_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'add_transaction.dart';

class AddTransactionImpl implements AddTransaction {
  final TransactionRepository transactionRepository;

  AddTransactionImpl({required this.transactionRepository});

  @override
  Future<TransactionEntity> call(
      Map<String, dynamic> data, String token) async {
    return await transactionRepository.addTransaction(data, token);
  }
}
