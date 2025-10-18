import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../base/base_controller.dart';
import '../models/transaction.dart';
import '../repo/transaction_repo.dart';

class TransactionFormController extends BaseDetailController {
  final TransactionRepo transactionRepo = Get.find<TransactionRepo>();

  // Form controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  // Form data
  DateTime selectedDate = DateTime.now();
  TransactionType selectedType = TransactionType.pengeluaran;

  // Edit mode
  bool isEditMode = false;
  Id? transactionId;

  // Available categories (you can load this from CategoryRepo if needed)
  List<String> suggestedCategories = [
    'Food',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills',
    'Salary',
    'Investment',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    if (Get.arguments != null && Get.arguments is Transaction) {
      loadTransaction(Get.arguments as Transaction);
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  /// Load transaction for editing
  void loadTransaction(Transaction transaction) {
    isEditMode = true;
    transactionId = transaction.id;

    amountController.text = (transaction.amount / 100).toStringAsFixed(2);
    descriptionController.text = transaction.description ?? '';
    categoryController.text = transaction.category ?? '';
    selectedDate = transaction.date;
    selectedType = transaction.type;

    update();
  }

  /// Update selected date
  void updateDate(DateTime date) {
    selectedDate = date;
    update();
  }

  /// Update transaction type
  void updateType(TransactionType type) {
    selectedType = type;
    update();
  }

  /// Validate form
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    if (value.length < 3) {
      return 'Description must be at least 3 characters';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a category';
    }
    return null;
  }

  /// Save transaction
  Future<bool> saveTransaction() async {
    setLoading(true);

    try {
      // Create transaction object
      final transaction = Transaction()
        ..date = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        )
        ..type = selectedType
        ..description = descriptionController.text.trim()
        ..category = categoryController.text.trim()
        ..amount = (double.parse(amountController.text)).round();

      // If edit mode, set the ID
      if (isEditMode && transactionId != null) {
        transaction.id = transactionId!;
      }

      // Save to database
      final result = isEditMode
          ? await transactionRepo.updateTransaction(transaction)
          : await transactionRepo.createTransaction(transaction);

      setLoading(false);

      if (result.hasData) {
        return true;
      }

      if (result.hasError) {
        error = result.error!;
      }

      return false;
    } catch (e) {
      error = 'Error saving transaction: $e';
      setLoading(false);
      return false;
    }
  }
}
