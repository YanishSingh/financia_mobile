import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/presentation/widgets/transaction_table.dart';
import '../viewmodels/transaction_viewmodel.dart';
import '../widgets/transaction_form.dart';

const List<String> monthNames = [
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

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final token = await authVM.getToken();
    final transactionVM =
        Provider.of<TransactionViewModel>(context, listen: false);
    await transactionVM.fetchTransactions(token!);
  }

  /// Opens a bottom sheet form for adding a new transaction.
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
          await _loadTransactions();
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

  /// Opens the update form prefilled with transaction data.
  void _openUpdateForm(TransactionEntity tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TransactionForm(
        transactionType: tx.type,
        existingTransaction: tx,
        onSubmit: (updatedTx) async {
          final authVM = Provider.of<AuthViewModel>(context, listen: false);
          final token = await authVM.getToken();
          final transactionVM =
              Provider.of<TransactionViewModel>(context, listen: false);
          await transactionVM.updateTransaction(tx.id, updatedTx, token!);
          Navigator.pop(context);
          await _loadTransactions();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.amber,
                content: Text(
                  'Transaction updated successfully.',
                  style: TextStyle(color: Colors.white),
                )),
          );
        },
      ),
    );
  }

  /// Shows a dialog to choose between updating and deleting.
  void _showOptionsDialog(TransactionEntity tx) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Action'),
        content:
            const Text('Do you want to update or delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openUpdateForm(tx);
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authVM = Provider.of<AuthViewModel>(context, listen: false);
              final token = await authVM.getToken();
              final transactionVM =
                  Provider.of<TransactionViewModel>(context, listen: false);
              await transactionVM.deleteTransaction(tx.id, token!);
              await _loadTransactions();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    'Transaction deleted successfully.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final transactionVM = Provider.of<TransactionViewModel>(context);
    final userName = authVM.user?['name'] ?? "User";

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Message
              Text(
                'Hello, $userName! Here are your transactions for $selectedMonth/$selectedYear:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              // Buttons for adding transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_downward, color: Colors.white),
                    label: const Text('Add Expense',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () => _openAddTransactionForm('expense'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    label: const Text('Add Income',
                        style: TextStyle(color: Colors.white)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _openAddTransactionForm('income'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Dropdowns for filtering by month and year
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(
                        12,
                        (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text(monthNames[index]),
                            )),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMonth = value;
                        });
                        _loadTransactions();
                      }
                    },
                  ),
                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(5, (index) {
                      int year = DateTime.now().year - index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text('$year'),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedYear = value;
                        });
                        _loadTransactions();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Transaction Table Widget – pass the transactions list from the view model.
              TransactionTable(
                transactions: transactionVM.transactions,
                onLongPress: _showOptionsDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
