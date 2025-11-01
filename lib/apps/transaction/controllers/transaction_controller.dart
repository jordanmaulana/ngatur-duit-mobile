import 'package:isar_community/isar.dart';

import '../../../base/base_controller.dart';
import '../models/transaction.dart';
import '../repo/transaction_repo.dart';

class TransactionController extends BaseDetailController {
  final TransactionRepo transactionRepo = Get.find<TransactionRepo>();

  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];

  // Filter options
  TransactionType? selectedType;
  String? selectedCategory;
  DateTime? startDate;
  DateTime? endDate;

  // Categories for filtering
  List<String> categories = [];

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  /// Load all transactions
  Future<void> loadTransactions() async {
    setLoading(true);

    final result = await transactionRepo.getAllTransactions(
      type: selectedType,
      category: selectedCategory,
      startDate: startDate,
      endDate: endDate,
      sortByDateDesc: true,
    );

    result.when(
      onSuccess: (data) {
        transactions = data;
        filteredTransactions = data;
        _extractCategories();
        error = '';
      },
      onFailure: (err) {
        error = err;
      },
    );

    setLoading(false);
  }

  /// Extract unique categories from transactions
  void _extractCategories() {
    final categorySet = <String>{};
    for (var transaction in transactions) {
      if (transaction.category != null && transaction.category!.isNotEmpty) {
        categorySet.add(transaction.category!);
      }
    }
    categories = categorySet.toList()..sort();
  }

  /// Filter transactions by type
  void filterByType(TransactionType? type) {
    selectedType = type;
    loadTransactions();
  }

  /// Filter transactions by category
  void filterByCategory(String? category) {
    selectedCategory = category;
    loadTransactions();
  }

  /// Filter transactions by date range
  void filterByDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    loadTransactions();
  }

  /// Clear all filters
  void clearFilters() {
    selectedType = null;
    selectedCategory = null;
    startDate = null;
    endDate = null;
    loadTransactions();
  }

  /// Delete a transaction
  Future<bool> deleteTransaction(Id id) async {
    final result = await transactionRepo.deleteTransaction(id);

    if (result.hasData && result.data == true) {
      await loadTransactions();
      return true;
    }

    if (result.hasError) {
      error = result.error!;
    }

    return false;
  }

  /// Get transaction by ID
  Future<Transaction?> getTransactionById(Id id) async {
    final result = await transactionRepo.getTransactionById(id);

    if (result.hasData) {
      return result.data;
    }

    if (result.hasError) {
      error = result.error!;
    }

    return null;
  }

  /// Calculate total income
  int getTotalIncome() {
    return filteredTransactions
        .where((t) => t.type == TransactionType.pemasukan)
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  /// Calculate total expenses
  int getTotalExpenses() {
    return filteredTransactions
        .where((t) => t.type == TransactionType.pengeluaran)
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  /// Calculate balance
  int getBalance() {
    return getTotalIncome() - getTotalExpenses();
  }
}
