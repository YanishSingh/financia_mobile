// lib/features/dashboard/data/datasources/remote_dashboard_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:financia_app/core/constants/app_constants.dart';

abstract class RemoteDashboardDataSource {
  Future<List<dynamic>> fetchTransactions(String token);
}

class RemoteDashboardDataSourceImpl implements RemoteDashboardDataSource {
  final http.Client client;

  RemoteDashboardDataSourceImpl({required this.client});

  @override
  Future<List<dynamic>> fetchTransactions(String token) async {
    // Use your API base URL from your constants (adjust for emulator if needed)
    final url = Uri.parse('${AppConstants.baseUrl}/api/transactions');
    final response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch transactions: ${response.body}');
    }
  }
}
