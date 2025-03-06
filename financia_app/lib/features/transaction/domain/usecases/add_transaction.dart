import '../entities/transaction_entity.dart';

abstract class AddTransaction {
  Future<TransactionEntity> call(Map<String, dynamic> data, String token);
}
