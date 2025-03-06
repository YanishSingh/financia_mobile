abstract class TransactionRemoteDataSource {
  Future<Map<String, dynamic>> addTransaction(
      Map<String, dynamic> data, String token);
  Future<List<dynamic>> getTransactions(String token);
  Future<Map<String, dynamic>> updateTransaction(
      String id, Map<String, dynamic> data, String token);
  Future<void> deleteTransaction(String id, String token);
  Future<Map<String, dynamic>> getMonthlySummary(
      int month, int year, String token);
}
