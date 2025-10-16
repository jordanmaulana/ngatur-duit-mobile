import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../transaction/models/transaction.dart';
import '../../transaction/repo/transaction_repo.dart';

class DashboardController extends GetxController {
  final TransactionRepo transactionRepo = Get.find<TransactionRepo>();

  // Observable data
  RxList<Transaction> transactions = <Transaction>[].obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpenses = 0.obs;
  RxInt balance = 0.obs;
  RxBool isLoading = true.obs;
  RxString selectedMonth = 'December'.obs;

  // Category data for the chart
  RxList<CategoryData> categoryData = <CategoryData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;

    try {
      // Get all transactions
      final result = await transactionRepo.getAllTransactions();

      result.when(
        onSuccess: (data) {
          transactions.value = data;
          calculateFinancials();
          generateCategoryData();
          isLoading.value = false;
        },
        onFailure: (error) {
          isLoading.value = false;
          print('Error loading dashboard data: $error');
        },
      );
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    }
  }

  void calculateFinancials() {
    final income = transactions
        .where((t) => t.type == TransactionType.pemasukan)
        .fold<int>(0, (sum, t) => sum + t.amount);

    final expenses = transactions
        .where((t) => t.type == TransactionType.pengeluaran)
        .fold<int>(0, (sum, t) => sum + t.amount);

    totalIncome.value = income;
    totalExpenses.value = expenses;
    balance.value = income - expenses;
  }

  void generateCategoryData() {
    // Group expenses by category
    final Map<String, int> categoryTotals = {};

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.pengeluaran &&
          transaction.category != null) {
        categoryTotals[transaction.category!] =
            (categoryTotals[transaction.category!] ?? 0) + transaction.amount;
      }
    }

    // Convert to CategoryData list
    final List<CategoryData> data = [];
    final totalExpenseAmount = totalExpenses.value;

    categoryTotals.forEach((category, amount) {
      final percentage = totalExpenseAmount > 0
          ? ((amount / totalExpenseAmount) * 100).round()
          : 0;

      data.add(CategoryData(
        name: category,
        amount: amount,
        percentage: percentage,
        color: _getCategoryColor(category),
        icon: _getCategoryIcon(category),
      ));
    });

    // Sort by amount descending
    data.sort((a, b) => b.amount.compareTo(a.amount));
    categoryData.value = data;
  }

  Color _getCategoryColor(String category) {
    // Assign colors based on category
    switch (category.toLowerCase()) {
      case 'housing':
      case 'home':
        return const Color(0xFF87CEEB); // Light blue
      case 'transportation':
      case 'car':
        return const Color(0xFF696969); // Dark gray
      case 'food':
      case 'dining':
        return const Color(0xFFFFA500); // Orange
      case 'shopping':
        return const Color(0xFFFF69B4); // Pink
      case 'healthcare':
      case 'medical':
        return const Color(0xFFFF0000); // Red
      case 'entertainment':
        return const Color(0xFF9370DB); // Purple
      default:
        return const Color(0xFF32CD32); // Green
    }
  }

  String _getCategoryIcon(String category) {
    // Return icon names based on category
    switch (category.toLowerCase()) {
      case 'housing':
      case 'home':
        return 'home';
      case 'transportation':
      case 'car':
        return 'car';
      case 'food':
      case 'dining':
        return 'utensils';
      case 'shopping':
        return 'shopping-bag';
      case 'healthcare':
      case 'medical':
        return 'heart-pulse';
      case 'entertainment':
        return 'gamepad2';
      case 'clothing':
        return 'shirt';
      case 'pets':
        return 'cat';
      case 'phone':
        return 'phone';
      case 'gifts':
        return 'gift';
      default:
        return 'circle';
    }
  }

  void refreshData() {
    loadDashboardData();
  }
}

class CategoryData {
  final String name;
  final int amount;
  final int percentage;
  final Color color;
  final String icon;

  CategoryData({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}
