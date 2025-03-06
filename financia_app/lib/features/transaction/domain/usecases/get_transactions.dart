import '../entities/transaction_entity.dart';

abstract class GetTransactions {
  Future<List<TransactionEntity>> call(String token);
}
