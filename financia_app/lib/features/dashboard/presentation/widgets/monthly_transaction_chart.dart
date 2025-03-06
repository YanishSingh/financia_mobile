import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyTransactionChart extends StatefulWidget {
  final List<TransactionEntity> transactions;

  const MonthlyTransactionChart({super.key, this.transactions = const []});

  @override
  _MonthlyTransactionChartState createState() =>
      _MonthlyTransactionChartState();
}

class _MonthlyTransactionChartState extends State<MonthlyTransactionChart> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // Aggregate income transactions by day.
  Map<int, double> _getIncomeSummary() {
    Map<int, double> summary = {};
    final filtered = widget.transactions.where((tx) =>
        tx.date.month == selectedMonth &&
        tx.date.year == selectedYear &&
        tx.type == 'income');
    for (var tx in filtered) {
      int day = tx.date.day;
      summary[day] = (summary[day] ?? 0) + tx.amount;
    }
    return summary;
  }

  // Aggregate expense transactions by day.
  Map<int, double> _getExpenseSummary() {
    Map<int, double> summary = {};
    final filtered = widget.transactions.where((tx) =>
        tx.date.month == selectedMonth &&
        tx.date.year == selectedYear &&
        tx.type == 'expense');
    for (var tx in filtered) {
      int day = tx.date.day;
      summary[day] = (summary[day] ?? 0) + tx.amount;
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final incomeSummary = _getIncomeSummary();
    final expenseSummary = _getExpenseSummary();

    List<FlSpot> incomeSpots = incomeSummary.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    incomeSpots.sort((a, b) => a.x.compareTo(b.x));

    List<FlSpot> expenseSpots = expenseSummary.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    expenseSpots.sort((a, b) => a.x.compareTo(b.x));

    // Determine if there's no data for the selected month.
    final bool noDataAvailable = incomeSpots.isEmpty && expenseSpots.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month and Year dropdowns.
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton<int>(
              value: selectedMonth,
              items: List.generate(12, (index) => index + 1).map((month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value!;
                });
              },
            ),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedYear,
              items: List.generate(10, (index) => DateTime.now().year - index)
                  .map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedYear = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Display "No data available" if there are no transactions.
        noDataAvailable
            ? const Center(child: Text('No data available'))
            : SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    // Enable touch interaction to show a tooltip on dot tap.
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              spot.y.toStringAsFixed(2),
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    // Show only the x-axis labels.
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineBarsData: [
                      if (incomeSpots.isNotEmpty)
                        LineChartBarData(
                          spots: incomeSpots,
                          isCurved: true,
                          color: Colors.green.shade400,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.green,
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                      if (expenseSpots.isNotEmpty)
                        LineChartBarData(
                          spots: expenseSpots,
                          isCurved: true,
                          color: Colors.red.shade400,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.red,
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
