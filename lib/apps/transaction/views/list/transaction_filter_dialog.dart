import 'package:flutter/material.dart';

import '../../controllers/transaction_controller.dart';
import '../../models/transaction.dart';

class TransactionFilterDialog extends StatelessWidget {
  final TransactionController controller;

  const TransactionFilterDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Transactions'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type filter
            const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: controller.selectedType == null,
                  onSelected: (_) {
                    controller.filterByType(null);
                    Navigator.pop(context);
                  },
                ),
                FilterChip(
                  label: const Text('Income'),
                  selected:
                      controller.selectedType == TransactionType.pemasukan,
                  onSelected: (_) {
                    controller.filterByType(TransactionType.pemasukan);
                    Navigator.pop(context);
                  },
                ),
                FilterChip(
                  label: const Text('Expense'),
                  selected:
                      controller.selectedType == TransactionType.pengeluaran,
                  onSelected: (_) {
                    controller.filterByType(TransactionType.pengeluaran);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Category filter
            if (controller.categories.isNotEmpty) ...[
              const Text('Category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: controller.selectedCategory == null,
                    onSelected: (_) {
                      controller.filterByCategory(null);
                      Navigator.pop(context);
                    },
                  ),
                  ...controller.categories.map((category) {
                    return FilterChip(
                      label: Text(category),
                      selected: controller.selectedCategory == category,
                      onSelected: (_) {
                        controller.filterByCategory(category);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.clearFilters();
            Navigator.pop(context);
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  static void show(BuildContext context, TransactionController controller) {
    showDialog(
      context: context,
      builder: (context) => TransactionFilterDialog(controller: controller),
    );
  }
}
