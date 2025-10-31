import 'package:isar_community/isar.dart';

import '../../../base/resource.dart';
import '../models/wallet.dart';

class WalletRepository {
  final Isar _isar;

  WalletRepository(this._isar);

  /// Get all wallets
  Future<Resource<List<Wallet>, String>> getAllWallets() async {
    try {
      final wallets = await _isar.wallets.where().findAll();
      return Resource.success(wallets);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Get wallet by ID
  Future<Resource<Wallet?, String>> getWalletById(int id) async {
    try {
      final wallet = await _isar.wallets.get(id);
      return Resource.success(wallet);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Get default wallet (first wallet in the database)
  Future<Resource<Wallet?, String>> getDefaultWallet() async {
    try {
      final wallet = await _isar.wallets.where().findFirst();
      return Resource.success(wallet);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Create a new wallet
  Future<Resource<int, String>> createWallet(Wallet wallet) async {
    try {
      final id = await _isar.writeTxn(() async {
        wallet.createdAt = DateTime.now();
        wallet.updatedAt = DateTime.now();
        return await _isar.wallets.put(wallet);
      });
      return Resource.success(id);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Update an existing wallet
  Future<Resource<bool, String>> updateWallet(Wallet wallet) async {
    try {
      await _isar.writeTxn(() async {
        wallet.updatedAt = DateTime.now();
        await _isar.wallets.put(wallet);
      });
      return Resource.success(true);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Delete a wallet
  Future<Resource<bool, String>> deleteWallet(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.wallets.delete(id);
      });
      return Resource.success(true);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Check if any wallets exist
  Future<Resource<bool, String>> hasWallets() async {
    try {
      final count = await _isar.wallets.count();
      return Resource.success(count > 0);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }

  /// Create default wallet if none exists
  Future<Resource<Wallet, String>> ensureDefaultWallet() async {
    try {
      // Check if any wallet exists
      final existingWallet = await _isar.wallets.where().findFirst();

      if (existingWallet != null) {
        return Resource.success(existingWallet);
      }

      // Create default wallet
      final defaultWallet = Wallet()
        ..name = 'Dompet Utama'
        ..synchronized = false
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      final id = await _isar.writeTxn(() async {
        return await _isar.wallets.put(defaultWallet);
      });

      defaultWallet.id = id;
      return Resource.success(defaultWallet);
    } catch (e) {
      return Resource.failure(e.toString());
    }
  }
}
