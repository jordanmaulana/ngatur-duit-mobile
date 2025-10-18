import 'package:flutter/material.dart';

import '../../../base/export_view.dart';
import '../models/transaction.dart';

/// Example of how to integrate transaction views into your app
///
/// This file shows different ways to navigate to transaction pages

class TransactionIntegrationExamples {
  /// Example 1: Add to main navigation/dashboard
  static Widget buildDashboardButton(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: VColor.primary),
        title: const VText('Transactions', fontWeight: FontWeight.w600),
        subtitle: const VText('View and manage your transactions'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to transaction list
          Get.toNamed('/transactions');
        },
      ),
    );
  }

  /// Example 2: Quick action to add transaction
  static Widget buildQuickAddButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate directly to form
        Get.toNamed('/transaction-form');
      },
      icon: const Icon(Icons.add),
      label: const VText('Add Transaction', color: Colors.white),
      backgroundColor: VColor.primary,
    );
  }

  /// Example 3: Navigate with initial data for editing
  static void navigateToEditTransaction(Transaction transaction) {
    Get.toNamed(
      '/transaction-form',
      arguments: transaction, // Pass transaction to edit
    );
  }

  /// Example 4: Menu item in app drawer
  static Widget buildDrawerMenuItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt_long),
      title: const Text('My Transactions'),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Get.toNamed('/transactions');
      },
    );
  }

  /// Example 5: Bottom navigation integration
  static BottomNavigationBarItem buildBottomNavItem() {
    return const BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long),
      label: 'Transactions',
    );
  }

  /// Example 6: Add to route definitions
  ///
  /// Add this to your main.dart getPages list:
  /// ```dart
  /// GetPage(
  ///   name: '/transactions',
  ///   page: () => const TransactionListPage(),
  ///   binding: BindingsBuilder(() {
  ///     Get.lazyPut(() => TransactionController());
  ///   }),
  /// ),
  /// GetPage(
  ///   name: '/transaction-form',
  ///   page: () => const TransactionFormPage(),
  ///   binding: BindingsBuilder(() {
  ///     Get.lazyPut(() => TransactionFormController());
  ///   }),
  /// ),
  /// ```

  /// Example 7: Add to RouteName constants
  ///
  /// Add this to your configs/route_name.dart:
  /// ```dart
  /// class RouteName {
  ///   static const String transactions = '/transactions';
  ///   static const String transactionForm = '/transaction-form';
  ///   // ... other routes
  /// }
  /// ```
}
