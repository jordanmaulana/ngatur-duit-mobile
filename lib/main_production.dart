import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'apps/wallet/repositories/wallet_repository.dart';
import 'configs/flavors.dart';
import 'main.dart';
import 'utilities/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize get storage.
  await GetStorage.init();

  /// Initialize build flavor.
  Get.put(BuildFlavor.initiate(buildFlavorType: BuildFlavorType.production));

  /// Initialize Isar database
  final isar = await IsarService.getInstance();

  /// Ensure default wallet exists
  final walletRepo = WalletRepository(isar);
  await walletRepo.ensureDefaultWallet();

  runApp(const MyApp());
}
