import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../apps/transaction/models/category.dart';
import '../apps/transaction/models/transaction.dart';

/// Isar database service for managing local database
class IsarService {
  static Isar? _isar;

  /// Get Isar instance, initialize if not already done
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TransactionSchema, CategorySchema],
      directory: dir.path,
    );

    return _isar!;
  }

  /// Close Isar instance
  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  /// Clear all data (useful for testing)
  static Future<void> clearAll() async {
    final isar = await getInstance();
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
