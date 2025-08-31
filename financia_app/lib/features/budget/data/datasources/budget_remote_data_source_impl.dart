import 'dart:convert';

import 'package:financia_app/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

import '../models/budget_model.dart';
import 'budget_remote_data_source.dart';

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final http.Client client;

  BudgetRemoteDataSourceImpl({required this.client});

  // Append the budgets endpoint to the base URL from AppConstants.
  final String budgetsEndpoint = '/api/budgets';

  @override
  Future<List<BudgetModel>> fetchBudgets(String token) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}$budgetsEndpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body) as List;
      return decoded.map((json) => BudgetModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  @override
  Future<BudgetModel> createBudget(
      Map<String, dynamic> budgetData, String token) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}$budgetsEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(budgetData),
    );
    if (response.statusCode == 201) {
      return BudgetModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create budget');
    }
  }

  @override
  Future<BudgetModel> updateBudget(
      String id, Map<String, dynamic> budgetData, String token) async {
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}$budgetsEndpoint/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(budgetData),
    );
    if (response.statusCode == 200) {
      return BudgetModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update budget');
    }
  }

  @override
  Future<void> deleteBudget(String id, String token) async {
    final response = await client.delete(
      Uri.parse('${AppConstants.baseUrl}$budgetsEndpoint/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete budget');
    }
  }
}
