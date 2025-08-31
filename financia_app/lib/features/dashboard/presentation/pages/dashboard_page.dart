import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../dashboard/presentation/widgets/monthly_transaction_chart.dart';
import '../../../dashboard/presentation/widgets/transaction_table.dart';
import '../../../transaction/presentation/viewmodels/transaction_viewmodel.dart';
import '../../../transaction/presentation/widgets/transaction_form.dart';
import '../widgets/finance_tip.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Opens the bottom sheet form for adding a transaction.
  void _openAddTransactionForm(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TransactionForm(
        transactionType: type,
        onSubmit: (newTx) async {
          final authVM = Provider.of<AuthViewModel>(context, listen: false);
          final token = await authVM.getToken();
          final transactionVM =
              Provider.of<TransactionViewModel>(context, listen: false);
          await transactionVM.addTransaction(newTx, token!);
          Navigator.pop(context);
          await transactionVM.fetchTransactions(token);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Transaction added successfully.'),
              backgroundColor: type == 'income' ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final transactionVM = Provider.of<TransactionViewModel>(context);
    // Assuming authVM.user is a Map that contains the user's details.
    final userName = authVM.user?['name'] ?? "User";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'DASHBOARD',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final token = await authVM.getToken();
          await transactionVM.fetchTransactions(token!);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Message
              Text(
                'Hello, $userName! Welcome to Financia!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              // Buttons for adding transactions (opens bottom sheet forms)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_downward, color: Colors.white),
                    label: const Text(
                      'Add Expense',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () => _openAddTransactionForm('expense'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    label: const Text(
                      'Add Income',
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _openAddTransactionForm('income'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Transaction Table (displaying recent transactions)
              TransactionTable(transactions: transactionVM.transactions),
              const SizedBox(height: 20),
              // Line Chart for monthly transactions
              MonthlyTransactionChart(transactions: transactionVM.transactions),
              const SizedBox(height: 20),
              // Finance Tip Section
              const FinanceTip(),
            ],
          ),
        ),
      ),
    );
  }
}
