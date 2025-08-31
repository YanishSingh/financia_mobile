// lib/features/dashboard/viewmodels/dashboard_viewmodel.dart
import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionModel {
  final String id;
  final String type;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      type: json['type'],
      category: json['category'],
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}

class DashboardViewModel extends ChangeNotifier {
  String userName = "User"; // Replace with actual user info.
  List<TransactionModel> transactions = [];
  LineChartData? chartData;
  String financeTip = "";
  int selectedMonth = DateTime.now().month; // 1-indexed
  int selectedYear = DateTime.now().year;

  final List<String> monthNames = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  DashboardViewModel() {
    financeTip = _randomTip();
    Timer.periodic(const Duration(minutes: 2), (timer) {
      financeTip = _randomTip();
      notifyListeners();
    });
    fetchTransactions();
  }

  String _randomTip() {
    List<String> tips = [
      "Save at least 20% of your income every month.",
      "Track your daily expenses to understand your spending habits.",
      "Invest in diversified assets for long-term growth.",
      "Create a realistic budget and stick to it.",
      "Avoid impulse purchases—wait 24 hours before buying.",
      "Maintain an emergency fund for unexpected expenses.",
      "Review subscriptions and cancel unused ones.",
      "Plan your retirement early for better financial security.",
      "Use cash instead of credit to prevent overspending.",
      "Regularly review and adjust your budget."
    ];
    tips.shuffle();
    return tips.first;
  }

  Future<void> fetchTransactions() async {
    try {
      // Use your backend API URL here.
      final url = Uri.parse("http://10.0.2.2:5000/api/transactions");
      // Replace with your actual JWT token retrieval logic.
      const String token = "YOUR_JWT_TOKEN_HERE";
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Filter transactions for the selected month and year.
        transactions = data
            .map((json) => TransactionModel.fromJson(json))
            .where((tx) =>
                tx.date.month == selectedMonth && tx.date.year == selectedYear)
            .toList();
        _computeChartData();
        notifyListeners();
      } else {
        print("Error fetching transactions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  void _computeChartData() {
    Map<int, double> incomeByDay = {};
    Map<int, double> expenseByDay = {};
    for (var tx in transactions) {
      int day = tx.date.day;
      if (tx.type == 'income') {
        incomeByDay[day] = (incomeByDay[day] ?? 0) + tx.amount;
      } else if (tx.type == 'expense') {
        expenseByDay[day] = (expenseByDay[day] ?? 0) + tx.amount;
      }
    }
    Set<int> days = {...incomeByDay.keys, ...expenseByDay.keys};
    List<int> sortedDays = days.toList()..sort();
    List<FlSpot> incomeSpots = sortedDays
        .map((day) => FlSpot(day.toDouble(), incomeByDay[day] ?? 0))
        .toList();
    List<FlSpot> expenseSpots = sortedDays
        .map((day) => FlSpot(day.toDouble(), expenseByDay[day] ?? 0))
        .toList();
    chartData = LineChartData(
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString());
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: incomeSpots,
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
        LineChartBarData(
          spots: expenseSpots,
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }

  void updateMonthYear(int month, int year) {
    selectedMonth = month;
    selectedYear = year;
    fetchTransactions();
  }
}
