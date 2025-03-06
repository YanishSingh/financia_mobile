import 'package:financia_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final String transactionType; // 'income' or 'expense'
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  final TransactionEntity? existingTransaction;

  const TransactionForm({
    super.key,
    required this.transactionType,
    required this.onSubmit,
    this.existingTransaction,
  });

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = [
    'Grocery',
    'Vehicle',
    'Travelling Expense',
    'Food & Beverages',
    'Rent',
    'Personal Use',
    'Entertainment',
    'Fees',
    'Government Fees',
    'Other',
  ];
  final List<String> _incomeCategories = [
    'Salary',
    'Gift',
    'Bonus',
    'Miscellaneous',
  ];

  List<String> get _categoryList => widget.transactionType == 'income'
      ? _incomeCategories
      : _expenseCategories;

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final tx = widget.existingTransaction!;
      _selectedCategory = tx.category;
      _amountController.text = tx.amount.toString();
      _descriptionController.text = tx.description ?? '';
      _selectedDate = tx.date;
    } else {
      _selectedCategory = _categoryList.first;
    }
  }

  Future<void> _presentDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Disallow future dates
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'type': widget.transactionType,
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'date': _selectedDate.toIso8601String(),
        'description': _descriptionController.text,
      };
      await widget.onSubmit(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Ensure the bottom sheet isn’t hidden by the keyboard.
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items: _categoryList
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a category'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (NPR)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter an amount';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
