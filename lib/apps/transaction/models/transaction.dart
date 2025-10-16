import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  /// Auto-incremented ID for the transaction
  Id id = Isar.autoIncrement;

  /// Date of the transaction without time
  /// Stored in UTC, but you should set the time to midnight for date-only storage
  late DateTime date;

  /// Type of transaction: either 'pengeluaran' (expense) or 'pemasukan' (income)
  @Enumerated(EnumType.name)
  late TransactionType type;

  /// Description of the transaction
  String? description;

  /// Category of the transaction
  String? category;

  /// Integer value of the transaction amount
  late int amount;
}

/// Enum for transaction types
enum TransactionType {
  /// Expense transaction
  pengeluaran,

  /// Income transaction
  pemasukan,
}
