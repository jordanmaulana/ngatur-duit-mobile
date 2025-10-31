import 'package:isar_community/isar.dart';

part 'wallet.g.dart';

@collection
class Wallet {
  /// Auto-incremented ID for the wallet
  Id id = Isar.autoIncrement;

  /// Optional online ID for syncing with remote services
  String? onlineId;

  /// Synchronization status
  /// If [onlineId] exists but [synchronized] is false, it means the wallet
  /// has been updated locally but not been synchronized with the remote service yet.
  bool synchronized = false;

  /// Name of the wallet
  late String name;

  /// Timestamp when the wallet was created
  late DateTime createdAt;

  /// Timestamp when the wallet was last updated
  late DateTime updatedAt;
}
