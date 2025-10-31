import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../utilities/isar_service.dart';
import '../models/wallet.dart';
import '../repositories/wallet_repository.dart';

class WalletFormController extends BaseDetailController {
  late final WalletRepository _walletRepository;
  final nameController = TextEditingController();

  bool isEditMode = false;
  int? walletId;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();

    // Check if we're in edit mode
    if (Get.arguments != null && Get.arguments is Wallet) {
      loadWallet(Get.arguments as Wallet);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  /// Initialize wallet repository
  Future<void> _initializeRepository() async {
    try {
      final isar = await IsarService.getInstance();
      _walletRepository = WalletRepository(isar);
    } catch (e) {
      error = 'Error initializing wallet repository: $e';
    }
  }

  /// Load wallet for editing
  void loadWallet(Wallet wallet) {
    isEditMode = true;
    walletId = wallet.id;
    nameController.text = wallet.name;
    update();
  }

  /// Validate form
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama dompet tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama dompet minimal 3 karakter';
    }
    return null;
  }

  /// Save wallet
  Future<bool> saveWallet() async {
    setLoading(true);

    try {
      final wallet = Wallet()
        ..name = nameController.text.trim()
        ..synchronized = false
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      // If edit mode, set the ID and update timestamps
      if (isEditMode && walletId != null) {
        wallet.id = walletId!;
        final existingResult = await _walletRepository.getWalletById(walletId!);
        if (existingResult.hasData && existingResult.data != null) {
          wallet.createdAt = existingResult.data!.createdAt;
          wallet.onlineId = existingResult.data!.onlineId;
        }
      }

      // Save to database
      final result = isEditMode
          ? await _walletRepository.updateWallet(wallet)
          : await _walletRepository.createWallet(wallet);

      setLoading(false);

      if (result.hasData) {
        return true;
      }

      if (result.hasError) {
        error = result.error!;
      }

      return false;
    } catch (e) {
      error = 'Error saving wallet: $e';
      setLoading(false);
      return false;
    }
  }
}
