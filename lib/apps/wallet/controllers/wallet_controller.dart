import '../../../base/base_controller.dart';
import '../../../utilities/isar_service.dart';
import '../models/wallet.dart';
import '../repositories/wallet_repository.dart';

class WalletController extends BaseDetailController {
  late final WalletRepository _walletRepository;
  List<Wallet> wallets = [];
  Wallet? selectedWallet;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
  }

  /// Initialize wallet repository
  Future<void> _initializeRepository() async {
    try {
      final isar = await IsarService.getInstance();
      _walletRepository = WalletRepository(isar);
      await loadWallets();
    } catch (e) {
      error = 'Error initializing wallet repository: $e';
    }
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

    setLoading(false);
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
