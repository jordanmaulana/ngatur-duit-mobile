import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../transaction/models/transaction.dart';
import '../../transaction/repo/transaction_repo.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Expense button (red with minus)
          _buildActionButton(
            color: const Color(0xFFFF5722), // Red
            icon: Icons.remove,
            onTap: () => _showAddTransactionDialog(context, isExpense: true),
          ),

          // Income button (green with plus)
          _buildActionButton(
            color: const Color(0xFF4CAF50), // Green
            icon: Icons.add,
            onTap: () => _showAddTransactionDialog(context, isExpense: false),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context,
      {required bool isExpense}) {
    showDialog(
      context: context,
      builder: (context) => AddTransactionDialog(
        isExpense: isExpense,
        onTransactionAdded: () {
          // Refresh dashboard data
          Get.find<DashboardController>().refreshData();
        },
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  final bool isExpense;
  final VoidCallback onTransactionAdded;

  const AddTransactionDialog({
    super.key,
    required this.isExpense,
    required this.onTransactionAdded,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isExpense ? 'Add Expense' : 'Add Income'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Amount field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category field
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date picker
            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTransaction,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      // Create transaction
      final transaction = Transaction()
        ..date = _selectedDate
        ..type = widget.isExpense
            ? TransactionType.pengeluaran
            : TransactionType.pemasukan
        ..description = _descriptionController.text
        ..category = _categoryController.text
        ..amount = (double.parse(_amountController.text) * 100)
            .round(); // Convert to cents

      // Save to database
      final transactionRepo = Get.find<TransactionRepo>();
      final result = await transactionRepo.createTransaction(transaction);

      result.when(
        onSuccess: (data) {
          Navigator.of(context).pop();
          widget.onTransactionAdded();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${widget.isExpense ? 'Expense' : 'Income'} added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onFailure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }
}
