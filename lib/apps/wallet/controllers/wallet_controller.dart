import '../../../base/base_controller.dart';

import '../../transaction/models/transaction.dart';
import '../../transaction/repo/transaction_repo.dart';
import '../models/wallet.dart';
import '../repositories/wallet_repository.dart';

class WalletController extends BaseDetailController {
  final WalletRepository _walletRepository = Get.find<WalletRepository>();
  final TransactionRepo _transactionRepo = Get.find<TransactionRepo>();
  List<Wallet> wallets = [];
  Wallet? selectedWallet;
  Map<int, WalletBalance> walletBalances = {};

  @override
  void onInit() {
    super.onInit();
    loadWallets();
  }

  /// Load all wallets
  Future<void> loadWallets() async {
    setLoading(true);

    final result = await _walletRepository.getAllWallets();

    result.when(
      onSuccess: (data) {
        wallets = data;
        error = '';
      },
      onFailure: (err) {
        error = err;
      },
    );

    await _calculateWalletBalances();
    setLoading(false);
  }

  /// Calculate balance for each wallet
  Future<void> _calculateWalletBalances() async {
    walletBalances.clear();

    final txResult = await _transactionRepo.getAllTransactions();
    if (!txResult.hasData) return;

    final allTransactions = txResult.data!;
    for (var wallet in wallets) {
      final walletTx = allTransactions
          .where((t) => t.walletId == wallet.id)
          .toList();

      final income = walletTx
          .where((t) => t.type == TransactionType.pemasukan)
          .fold<int>(0, (sum, t) => sum + t.amount);

      final expenses = walletTx
          .where((t) => t.type == TransactionType.pengeluaran)
          .fold<int>(0, (sum, t) => sum + t.amount);

      walletBalances[wallet.id] = WalletBalance(
        balance: income - expenses,
        income: income,
        expenses: expenses,
      );
    }
  }

  /// Delete a wallet
  Future<bool> deleteWallet(int id) async {
    final result = await _walletRepository.deleteWallet(id);

    if (result.hasData && result.data == true) {
      await loadWallets();
      return true;
    }

    if (result.hasError) {
      error = result.error!;
    }

    return false;
  }
}

class WalletBalance {
  final int balance;
  final int income;
  final int expenses;

  WalletBalance({
    required this.balance,
    required this.income,
    required this.expenses,
  });
}
