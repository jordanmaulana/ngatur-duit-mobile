import '../../../../base/export_view.dart';
import '../../../../ui/components/popup.dart';
import '../controllers/wallet_controller.dart';
import '../models/wallet.dart';
import 'wallet_form_page.dart';

class WalletListPage extends StatelessWidget {
  const WalletListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (WalletController controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: VColor.primary,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    VColor.primary,
                    Color(0xCC00786F),
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedWallet01,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                VText(
                  'Kelola Dompet',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          body: controller.loading
              ? const Center(child: CircularProgressIndicator())
              : controller.error.isNotEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedAlert02,
                              size: 48,
                              color: VColor.error,
                            ),
                            const SizedBox(height: 16),
                            VText(
                              controller.error,
                              color: VColor.error,
                              align: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : controller.wallets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedWallet03,
                                size: 80,
                                color: Color(0x8072678A),
                              ),
                              const SizedBox(height: 16),
                              VText(
                                'Belum ada dompet',
                                fontSize: 18,
                                color: VColor.greyText,
                              ),
                              const SizedBox(height: 8),
                              VText(
                                'Ketuk tombol + untuk menambah dompet',
                                fontSize: 14,
                                color: VColor.greyText,
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => controller.loadWallets(),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                            itemCount: controller.wallets.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final wallet = controller.wallets[index];
                              return _WalletItem(
                                wallet: wallet,
                                onDeleted: () =>
                                    VToast.success('Dompet berhasil dihapus'),
                              );
                            },
                          ),
                        ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToForm(context, controller),
            backgroundColor: VColor.primary,
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _navigateToForm(BuildContext context, WalletController controller,
      {Wallet? wallet}) async {
    final result = await Get.to(
      () => const WalletFormPage(),
      arguments: wallet,
    );

    if (result == true) {
      controller.loadWallets();
    }
  }
}

class _WalletItem extends GetView<WalletController> {
  final Wallet wallet;
  final VoidCallback onDeleted;

  const _WalletItem({
    required this.wallet,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToForm(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x1A00786F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedWallet03,
                  color: VColor.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VText(
                      wallet.name,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    VText(
                      'Dibuat: ${_formatDate(wallet.createdAt)}',
                      fontSize: 12,
                      color: VColor.greyText,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: VColor.error,
                  size: 20,
                ),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu lalu';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} bulan lalu';
    } else {
      return '${(difference.inDays / 365).floor()} tahun lalu';
    }
  }

  void _confirmDelete(BuildContext context) {
    VPopup.proceedWarning(
      title: 'Hapus Dompet',
      message: 'Apakah Anda yakin ingin menghapus dompet ini?',
      callback: () async {
        VPopup.loading();
        final success = await controller.deleteWallet(wallet.id);
        VPopup.pop();

        if (success) {
          onDeleted();
          VPopup.pop();
        } else {
          VPopup.error(controller.error);
        }
      },
    );
  }

  void _navigateToForm(BuildContext context) async {
    final result = await Get.to(
      () => const WalletFormPage(),
      arguments: wallet,
    );

    if (result == true) {
      controller.loadWallets();
    }
  }
}
