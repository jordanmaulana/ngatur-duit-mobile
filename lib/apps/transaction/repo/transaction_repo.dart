import 'package:isar_community/isar.dart';

import '../../../base/resource.dart';
import '../../../utilities/isar_service.dart';
import '../models/transaction.dart';

class TransactionRepo {
  /// Get Isar instance
  Future<Isar> get _isar => IsarService.getInstance();

  /// Create a new transaction
  Future<Resource<Transaction, String>> createTransaction(
      Transaction transaction) async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.transactions.put(transaction);
      });
      return transaction.toResourceSuccess();
    } catch (e) {
      return 'Failed to create transaction: $e'.toResourceFailure();
    }
  }

  /// Get a transaction by ID
  Future<Resource<Transaction?, String>> getTransactionById(Id id) async {
    try {
      final isar = await _isar;
      final transaction = await isar.transactions.get(id);
      return transaction.toResourceSuccess();
    } catch (e) {
      return 'Failed to get transaction: $e'.toResourceFailure();
    }
  }

  /// Get all transactions with optional filters and sorting
  ///
  /// Parameters:
  /// - [type] - Filter by transaction type (income/expense)
  /// - [category] - Filter by category name
  /// - [startDate] - Filter transactions from this date (inclusive)
  /// - [endDate] - Filter transactions until this date (inclusive)
  /// - [sortByDateDesc] - Sort by date in descending order (default: true)
  Future<Resource<List<Transaction>, String>> getAllTransactions({
    TransactionType? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    bool sortByDateDesc = true,
  }) async {
    try {
      final isar = await _isar;

      // Get all transactions
      var transactions = await isar.transactions.where().findAll();

      // Apply filters in memory
      if (type != null) {
        transactions = transactions.where((t) => t.type == type).toList();
      }

      if (category != null) {
        transactions =
            transactions.where((t) => t.category == category).toList();
      }

      if (startDate != null && endDate != null) {
        transactions = transactions.where((t) {
          return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
      } else if (startDate != null) {
        transactions = transactions
            .where((t) =>
                t.date.isAfter(startDate.subtract(const Duration(days: 1))))
            .toList();
      } else if (endDate != null) {
        transactions = transactions
            .where((t) => t.date.isBefore(endDate.add(const Duration(days: 1))))
            .toList();
      }

      // Apply sorting
      if (sortByDateDesc) {
        transactions.sort((a, b) => b.date.compareTo(a.date));
      } else {
        transactions.sort((a, b) => a.date.compareTo(b.date));
      }

      return transactions.toResourceSuccess();
    } catch (e) {
      return 'Failed to get transactions: $e'.toResourceFailure();
    }
  }

  /// Update a transaction
  Future<Resource<Transaction, String>> updateTransaction(
      Transaction transaction) async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.transactions.put(transaction);
      });
      return transaction.toResourceSuccess();
    } catch (e) {
      return 'Failed to update transaction: $e'.toResourceFailure();
    }
  }

  /// Delete a transaction by ID
  Future<Resource<bool, String>> deleteTransaction(Id id) async {
    try {
      final isar = await _isar;
      bool deleted = false;
      await isar.writeTxn(() async {
        deleted = await isar.transactions.delete(id);
      });
      return deleted.toResourceSuccess();
    } catch (e) {
      return 'Failed to delete transaction: $e'.toResourceFailure();
    }
  }

  /// Delete multiple transactions by IDs
  Future<Resource<int, String>> deleteTransactions(List<Id> ids) async {
    try {
      final isar = await _isar;
      int count = 0;
      await isar.writeTxn(() async {
        count = await isar.transactions.deleteAll(ids);
      });
      return count.toResourceSuccess();
    } catch (e) {
      return 'Failed to delete transactions: $e'.toResourceFailure();
    }
  }

  /// Delete all transactions
  Future<Resource<bool, String>> deleteAllTransactions() async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.transactions.clear();
      });
      return true.toResourceSuccess();
    } catch (e) {
      return 'Failed to delete all transactions: $e'.toResourceFailure();
    }
  }

  /// Get total income
  Future<Resource<int, String>> getTotalIncome() async {
    try {
      final isar = await _isar;
      final transactions = await isar.transactions
          .filter()
          .typeEqualTo(TransactionType.pemasukan)
          .findAll();
      final total = transactions.fold<int>(0, (sum, t) => sum + t.amount);
      return total.toResourceSuccess();
    } catch (e) {
      return 'Failed to calculate total income: $e'.toResourceFailure();
    }
  }

  /// Get total expenses
  Future<Resource<int, String>> getTotalExpenses() async {
    try {
      final isar = await _isar;
      final transactions = await isar.transactions
          .filter()
          .typeEqualTo(TransactionType.pengeluaran)
          .findAll();
      final total = transactions.fold<int>(0, (sum, t) => sum + t.amount);
      return total.toResourceSuccess();
    } catch (e) {
      return 'Failed to calculate total expenses: $e'.toResourceFailure();
    }
  }

  /// Get balance (income - expenses)
  Future<Resource<int, String>> getBalance() async {
    try {
      final incomeResult = await getTotalIncome();
      final expensesResult = await getTotalExpenses();

      if (incomeResult.hasError) {
        return incomeResult.error!.toResourceFailure();
      }
      if (expensesResult.hasError) {
        return expensesResult.error!.toResourceFailure();
      }

      final balance = (incomeResult.data ?? 0) - (expensesResult.data ?? 0);
      return balance.toResourceSuccess();
    } catch (e) {
      return 'Failed to calculate balance: $e'.toResourceFailure();
    }
  }
}
