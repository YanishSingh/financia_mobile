import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction_entity.dart';

class TransactionTable extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final Function(TransactionEntity) onLongPress;

  const TransactionTable({
    super.key,
    required this.transactions,
    required this.onLongPress,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions found.'));
    }
    // Show only 5 transactions if available.
    final displayList =
        transactions.length > 5 ? transactions.sublist(0, 5) : transactions;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        horizontalMargin: 5,
        columns: const [
          DataColumn(
            label: Text('S.N', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label:
                Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Center(
              child: Text('Amount (NPR)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        rows: List.generate(displayList.length, (index) {
          final tx = displayList[index];
          final isIncome = tx.type == 'income';
          final textColor = isIncome ? Colors.green : Colors.red;
          return DataRow(
            cells: [
              DataCell(
                Container(
                  width: 25,
                  alignment: Alignment.center,
                  child:
                      Text('${index + 1}', style: TextStyle(color: textColor)),
                ),
              ),
              DataCell(Text(_formatDate(tx.date),
                  style: TextStyle(color: textColor))),
              DataCell(Text(tx.category, style: TextStyle(color: textColor))),
              DataCell(
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(tx.amount.toString(),
                      style: TextStyle(color: textColor)),
                ),
              ),
            ],
            onLongPress: () => onLongPress(tx),
          );
        }),
      ),
    );
  }
}
