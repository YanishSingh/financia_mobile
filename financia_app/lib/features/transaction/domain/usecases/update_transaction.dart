import '../entities/transaction_entity.dart';

abstract class UpdateTransaction {
  Future<TransactionEntity> call(
      String id, Map<String, dynamic> updatedData, String token);
}
