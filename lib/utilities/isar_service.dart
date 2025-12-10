import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../apps/transaction/models/category.dart';
import '../apps/transaction/models/transaction.dart';
import '../apps/wallet/models/wallet.dart';

/// Isar database service for managing local database
class IsarService {
  static Isar? _isar;

  /// Get Isar instance, initialize if not already done
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      TransactionSchema,
      CategorySchema,
      WalletSchema,
    ], directory: dir.path);

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

  /// Populate database with sample wallets
  static Future<void> populateWallets() async {
    final isar = await getInstance();

    // Check if wallets already exist
    final existingWallets = await isar.wallets.where().findAll();
    if (existingWallets.isNotEmpty) {
      return; // Already populated
    }

    final now = DateTime.now();
    final wallets = [
      Wallet()
        ..name = 'Dompet Pribadi'
        ..createdAt = now
        ..updatedAt = now,
      Wallet()
        ..name = 'Tabungan'
        ..createdAt = now
        ..updatedAt = now,
      Wallet()
        ..name = 'Investasi'
        ..createdAt = now.subtract(const Duration(days: 7))
        ..updatedAt = now,
    ];

    await isar.writeTxn(() async {
      await isar.wallets.putAll(wallets);
    });
  }

  /// Populate database with sample transactions
  static Future<void> populateTransactions() async {
    final isar = await getInstance();

    // Check if transactions already exist
    final existingTransactions = await isar.transactions.where().findAll();
    if (existingTransactions.isNotEmpty) {
      return; // Already populated
    }

    // Get first wallet or create one
    var wallet = await isar.wallets.where().findFirst();
    if (wallet == null) {
      await populateWallets();
      wallet = await isar.wallets.where().findFirst();
    }

    final now = DateTime.now();
    final transactions = [
      // This week expenses
      Transaction()
        ..date = now
        ..type = TransactionType.pengeluaran
        ..category = 'Makanan'
        ..description = 'Sarapan di warung'
        ..amount = 45000
        ..walletId = wallet!.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 1))
        ..type = TransactionType.pengeluaran
        ..category = 'Transportasi'
        ..description = 'Bensin mobil'
        ..amount = 150000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 2))
        ..type = TransactionType.pengeluaran
        ..category = 'Utilitas'
        ..description = 'Listrik dan air'
        ..amount = 250000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 3))
        ..type = TransactionType.pengeluaran
        ..category = 'Hiburan'
        ..description = 'Nonton bioskop'
        ..amount = 150000
        ..walletId = wallet.id,

      // This week income
      Transaction()
        ..date = now.subtract(const Duration(days: 2))
        ..type = TransactionType.pemasukan
        ..category = 'Gaji'
        ..description = 'Gaji bulanan'
        ..amount = 5000000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 4))
        ..type = TransactionType.pemasukan
        ..category = 'Bonus'
        ..description = 'Bonus kinerja'
        ..amount = 1000000
        ..walletId = wallet.id,

      // Previous week
      Transaction()
        ..date = now.subtract(const Duration(days: 7))
        ..type = TransactionType.pengeluaran
        ..category = 'Belanja Kebutuhan'
        ..description = 'Belanja kebutuhan rumah'
        ..amount = 350000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 8))
        ..type = TransactionType.pengeluaran
        ..category = 'Kesehatan'
        ..description = 'Pembelian obat'
        ..amount = 85000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 9))
        ..type = TransactionType.pengeluaran
        ..category = 'Makanan'
        ..description = 'Makan siang bersama'
        ..amount = 65000
        ..walletId = wallet.id,

      // Two weeks ago
      Transaction()
        ..date = now.subtract(const Duration(days: 14))
        ..type = TransactionType.pengeluaran
        ..category = 'Fashion'
        ..description = 'Beli kaos baru'
        ..amount = 120000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 15))
        ..type = TransactionType.pengeluaran
        ..category = 'Asuransi'
        ..description = 'Premi asuransi bulanan'
        ..amount = 500000
        ..walletId = wallet.id,
      Transaction()
        ..date = now.subtract(const Duration(days: 16))
        ..type = TransactionType.pemasukan
        ..category = 'Freelance'
        ..description = 'Proyek freelance'
        ..amount = 2500000
        ..walletId = wallet.id,
    ];

    await isar.writeTxn(() async {
      await isar.transactions.putAll(transactions);
    });
  }

  /// Populate database with all sample data
  /// Useful for testing and demo purposes
  static Future<void> populateAll() async {
    await populateWallets();
    await populateTransactions();
  }
}
