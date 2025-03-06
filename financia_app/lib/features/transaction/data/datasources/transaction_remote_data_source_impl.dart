import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:financia_app/core/constants/app_constants.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final http.Client client;

  TransactionRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> addTransaction(
      Map<String, dynamic> data, String token) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add transaction: ${response.body}');
    }
  }

  @override
  Future<List<dynamic>> getTransactions(String token) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}/api/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to get transactions: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateTransaction(
      String id, Map<String, dynamic> data, String token) async {
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}/api/transactions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update transaction: ${response.body}');
    }
  }

  @override
  Future<void> deleteTransaction(String id, String token) async {
    final response = await client.delete(
      Uri.parse('${AppConstants.baseUrl}/api/transactions/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> getMonthlySummary(
      int month, int year, String token) async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.baseUrl}/api/transactions/summary?month=$month&year=$year'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch monthly summary: ${response.body}');
    }
  }
}
