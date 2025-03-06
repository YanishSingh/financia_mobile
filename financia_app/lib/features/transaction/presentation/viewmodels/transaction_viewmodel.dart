import 'package:flutter/material.dart';
import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:financia_app/features/transaction/domain/usecases/add_transaction.dart';
import 'package:financia_app/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:financia_app/features/transaction/domain/usecases/get_monthly_summary.dart';
import 'package:financia_app/features/transaction/domain/usecases/get_transactions.dart';
import 'package:financia_app/features/transaction/domain/usecases/update_transaction.dart';

class TransactionViewModel extends ChangeNotifier {
  final GetTransactions getTransactionsUseCase;
  final AddTransaction addTransactionUseCase;
  final UpdateTransaction updateTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;
  final GetMonthlySummary getMonthlySummaryUseCase;

  bool isLoading = false;
  List<TransactionEntity> transactions = [];
  Map<int, double> monthlySummary = {};

  TransactionViewModel({
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.getMonthlySummaryUseCase,
  });

  Future<void> fetchTransactions(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      transactions = await getTransactionsUseCase(token);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TransactionEntity> addTransaction(
      Map<String, dynamic> data, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await addTransactionUseCase(data, token);
      await fetchTransactions(token);
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TransactionEntity> updateTransaction(
      String id, Map<String, dynamic> updatedData, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await updateTransactionUseCase(id, updatedData, token);
      await fetchTransactions(token);
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      await deleteTransactionUseCase(id, token);
      await fetchTransactions(token);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<int, double>> fetchMonthlySummary(
      int month, int year, String token) async {
    return await getMonthlySummaryUseCase(month, year, token);
  }
}
