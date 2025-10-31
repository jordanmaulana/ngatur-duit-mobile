import '../../../../base/export_view.dart';
import '../../../../ui/components/loadings.dart';
import '../../../../ui/components/popup.dart';
import '../controllers/wallet_form_controller.dart';

class WalletFormPage extends StatelessWidget {
  const WalletFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return GetBuilder<WalletFormController>(
      init: WalletFormController(),
      builder: (controller) {
        return Scaffold(
          appBar: StandardAppbar(
            title: controller.isEditMode ? 'Edit Dompet' : 'Tambah Dompet',
            includeBackButton: true,
          ),
          body: controller.loading
              ? const VLoading()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                VColor.primary,
                                Color(0xCC00786F),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0x26FFFFFF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedWallet03,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VText(
                                      controller.isEditMode
                                          ? 'Edit Dompet'
                                          : 'Dompet Baru',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 4),
                                    VText(
                                      'Kelola dompet Anda dengan mudah',
                                      fontSize: 13,
                                      color: const Color(0xE6FFFFFF),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        VFormInput(
                          label: 'Nama Dompet',
                          hint: 'Contoh: Dompet Pribadi, Tabungan',
                          controller: controller.nameController,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedWallet03,
                              color: VColor.primary,
                            ),
                          ),
                          validator: controller.validateName,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0x1A00786F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedInformationCircle,
                                color: VColor.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: VText(
                                  'Buat dompet terpisah untuk mengelompokkan transaksi Anda',
                                  fontSize: 12,
                                  color: VColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          controller.isEditMode
                              ? 'Perbarui Dompet'
                              : 'Tambah Dompet',
                          onTap: () =>
                              _saveWallet(context, formKey, controller),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _saveWallet(
    BuildContext context,
    GlobalKey<FormState> formKey,
    WalletFormController controller,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    VPopup.loading();
    final success = await controller.saveWallet();
    VPopup.pop();

    if (success) {
      VToast.success(
        controller.isEditMode
            ? 'Dompet berhasil diperbarui'
            : 'Dompet berhasil ditambahkan',
      );
      Get.back(result: true);
    } else {
      VPopup.error(controller.error);
    }
  }
}
