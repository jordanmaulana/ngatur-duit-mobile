import '../../../base/base_controller.dart';
import '../../transaction/models/transaction.dart';
import '../../transaction/repo/transaction_repo.dart';
import '../../wallet/models/wallet.dart';
import '../../wallet/repositories/wallet_repository.dart';

class DashboardController extends BaseDetailController {
  final TransactionRepo transactionRepo = Get.find<TransactionRepo>();
  final WalletRepository _walletRepository = Get.find<WalletRepository>();

  List<Transaction> recentTransactions = [];
  List<Transaction> allTransactions = [];
  List<Wallet> wallets = [];
  Map<int, WalletBalance> walletBalances = {};

  // Summary data
  int totalIncome = 0;
  int totalExpenses = 0;
  int balance = 0;

  // Monthly data
  int monthlyIncome = 0;
  int monthlyExpenses = 0;
  int monthlyBalance = 0;
  DateTime selectedMonth = DateTime.now();

  // Top categories
  List<CategorySummary> topExpenseCategories = [];
  List<CategorySummary> topIncomeCategories = [];

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    setLoading(true);

    await Future.wait([
      _loadWallets(),
      _loadAllTransactions(),
      _loadMonthlyTransactions(),
      _loadRecentTransactions(),
    ]);

    _calculateSummary();
    _calculateWalletBalances();
    _calculateTopCategories();

    setLoading(false);
  }

  /// Load all wallets
  Future<void> _loadWallets() async {
    final result = await _walletRepository.getAllWallets();

    result.when(
      onSuccess: (data) {
        wallets = data;
      },
      onFailure: (err) {
        error = err;
      },
    );
  }

  /// Load all transactions
  Future<void> _loadAllTransactions() async {
    final result = await transactionRepo.getAllTransactions(
      sortByDateDesc: true,
    );

    result.when(
      onSuccess: (data) {
        allTransactions = data;
      },
      onFailure: (err) {
        error = err;
      },
    );
  }

  /// Load current month transactions
  Future<void> _loadMonthlyTransactions() async {
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    final result = await transactionRepo.getAllTransactions(
      startDate: startOfMonth,
      endDate: endOfMonth,
      sortByDateDesc: true,
    );

    result.when(
      onSuccess: (data) {
        monthlyIncome = data
            .where((t) => t.type == TransactionType.pemasukan)
            .fold<int>(0, (sum, t) => sum + t.amount);

        monthlyExpenses = data
            .where((t) => t.type == TransactionType.pengeluaran)
            .fold<int>(0, (sum, t) => sum + t.amount);

        monthlyBalance = monthlyIncome - monthlyExpenses;
      },
      onFailure: (err) {
        error = err;
      },
    );
  }

  /// Load recent transactions (last 5)
  Future<void> _loadRecentTransactions() async {
    final result = await transactionRepo.getAllTransactions(
      sortByDateDesc: true,
    );

    result.when(
      onSuccess: (data) {
        recentTransactions = data.take(5).toList();
      },
      onFailure: (err) {
        error = err;
      },
    );
  }

  /// Calculate overall summary
  void _calculateSummary() {
    totalIncome = allTransactions
        .where((t) => t.type == TransactionType.pemasukan)
        .fold<int>(0, (sum, t) => sum + t.amount);

    totalExpenses = allTransactions
        .where((t) => t.type == TransactionType.pengeluaran)
        .fold<int>(0, (sum, t) => sum + t.amount);

    balance = totalIncome - totalExpenses;
  }

  /// Calculate balance for each wallet
  void _calculateWalletBalances() {
    walletBalances.clear();

    for (var wallet in wallets) {
      final walletTransactions =
          allTransactions.where((t) => t.walletId == wallet.id).toList();

      final income = walletTransactions
          .where((t) => t.type == TransactionType.pemasukan)
          .fold<int>(0, (sum, t) => sum + t.amount);

      final expenses = walletTransactions
          .where((t) => t.type == TransactionType.pengeluaran)
          .fold<int>(0, (sum, t) => sum + t.amount);

      walletBalances[wallet.id] = WalletBalance(
        wallet: wallet,
        balance: income - expenses,
        income: income,
        expenses: expenses,
      );
    }
  }

  /// Calculate top categories by spending/income
  void _calculateTopCategories() {
    // Group expenses by category
    final expensesByCategory = <String, int>{};
    for (var transaction in allTransactions) {
      if (transaction.type == TransactionType.pengeluaran &&
          transaction.category != null) {
        expensesByCategory[transaction.category!] =
            (expensesByCategory[transaction.category!] ?? 0) +
                transaction.amount;
      }
    }

    // Group income by category
    final incomeByCategory = <String, int>{};
    for (var transaction in allTransactions) {
      if (transaction.type == TransactionType.pemasukan &&
          transaction.category != null) {
        incomeByCategory[transaction.category!] =
            (incomeByCategory[transaction.category!] ?? 0) + transaction.amount;
      }
    }

    // Sort and get top 5 expense categories
    topExpenseCategories = expensesByCategory.entries
        .map((e) => CategorySummary(category: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    topExpenseCategories = topExpenseCategories.take(5).toList();

    // Sort and get top 5 income categories
    topIncomeCategories = incomeByCategory.entries
        .map((e) => CategorySummary(category: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    topIncomeCategories = topIncomeCategories.take(5).toList();
  }

  /// Get percentage of category from total
  double getCategoryPercentage(int amount, TransactionType type) {
    final total =
        type == TransactionType.pengeluaran ? totalExpenses : totalIncome;
    if (total == 0) return 0;
    return (amount / total) * 100;
  }

  /// Change to previous month
  void previousMonth() {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    _loadMonthlyTransactions();
    update();
  }

  /// Change to next month
  void nextMonth() {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    _loadMonthlyTransactions();
    update();
  }

  /// Reset to current month
  void resetToCurrentMonth() {
    selectedMonth = DateTime.now();
    _loadMonthlyTransactions();
    update();
  }
}

/// Model for category summary
class CategorySummary {
  final String category;
  final int amount;

  CategorySummary({required this.category, required this.amount});
}

/// Model for wallet balance
class WalletBalance {
  final Wallet wallet;
  final int balance;
  final int income;
  final int expenses;

  WalletBalance({
    required this.wallet,
    required this.balance,
    required this.income,
    required this.expenses,
  });
}
