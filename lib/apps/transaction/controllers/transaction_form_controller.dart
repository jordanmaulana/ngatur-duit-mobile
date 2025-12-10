import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import '../../../base/base_controller.dart';
import '../../wallet/models/wallet.dart';
import '../../wallet/repositories/wallet_repository.dart';
import '../constants/category_suggestions.dart';
import '../models/transaction.dart';
import '../repo/transaction_repo.dart';

class TransactionFormController extends BaseDetailController {
  final TransactionRepo transactionRepo = Get.find<TransactionRepo>();
  final WalletRepository _walletRepository = Get.find<WalletRepository>();
  int? defaultWalletId;

  // Wallet selection
  List<Wallet> wallets = [];
  Wallet? selectedWallet;

  // Form controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  // Form data
  DateTime selectedDate = DateTime.now();
  TransactionType selectedType = TransactionType.pengeluaran;

  // Edit mode
  bool isEditMode = false;
  Id? transactionId;

  // Get suggested categories based on selected type
  List<String> get suggestedCategories {
    return selectedType == TransactionType.pemasukan
        ? incomeSuggestionCategories
        : expenseSuggestionCategories;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeWallet();

    // Check if we're in edit mode
    if (Get.arguments != null && Get.arguments is Transaction) {
      loadTransaction(Get.arguments as Transaction);
    }
  }

  /// Initialize wallet repository and get default wallet
  Future<void> _initializeWallet() async {
    try {
      // Load all wallets
      final walletsResult = await _walletRepository.getAllWallets();
      if (walletsResult.hasData) {
        wallets = walletsResult.data ?? [];
      }

      // Get default wallet
      final result = await _walletRepository.getDefaultWallet();
      if (result.hasData && result.data != null) {
        defaultWalletId = result.data!.id;
        selectedWallet = result.data;
      }

      update();
    } catch (e) {
      error = 'Error initializing wallet: $e';
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  /// Load transaction for editing
  void loadTransaction(Transaction transaction) {
    isEditMode = true;
    transactionId = transaction.id;

    amountController.text = (transaction.amount).toStringAsFixed(0);
    descriptionController.text = transaction.description ?? '';
    categoryController.text = transaction.category ?? '';
    selectedDate = transaction.date;
    selectedType = transaction.type;

    // Load wallet for this transaction
    selectedWallet =
        wallets.firstWhereOrNull((w) => w.id == transaction.walletId);

    update();
  }

  /// Update selected date
  void updateDate(DateTime date) {
    selectedDate = date;
    update();
  }

  /// Update transaction type
  void updateType(TransactionType type) {
    selectedType = type;
    update();
  }

  /// Update selected wallet
  void updateWallet(Wallet wallet) {
    selectedWallet = wallet;
    update();
  }

  /// Validate form
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    if (value.length < 3) {
      return 'Description must be at least 3 characters';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a category';
    }
    return null;
  }

  /// Save transaction
  Future<bool> saveTransaction() async {
    setLoading(true);

    try {
      // Ensure we have a wallet selected
      if (selectedWallet == null) {
        error = 'Silakan pilih dompet';
        setLoading(false);
        return false;
      }

      // Create transaction object
      final transaction = Transaction()
        ..date = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        )
        ..type = selectedType
        ..description = descriptionController.text.trim()
        ..category = categoryController.text.trim()
        ..amount = (double.parse(amountController.text)).round()
        ..walletId = selectedWallet!.id;

      // If edit mode, set the ID
      if (isEditMode && transactionId != null) {
        transaction.id = transactionId!;
      }

      // Save to database
      final result = isEditMode
          ? await transactionRepo.updateTransaction(transaction)
          : await transactionRepo.createTransaction(transaction);

      setLoading(false);

      if (result.hasData) {
        return true;
      }

      if (result.hasError) {
        error = result.error!;
      }

      return false;
    } catch (e) {
      error = 'Error saving transaction: $e';
      setLoading(false);
      return false;
    }
  }
}
