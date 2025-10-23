import 'package:intl/intl.dart';

import '../../../../base/export_view.dart';
import '../../../../ui/components/loadings.dart';
import '../../../../ui/components/popup.dart';
import '../../controllers/transaction_form_controller.dart';
import '../../models/transaction.dart';

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return GetBuilder<TransactionFormController>(
      init: TransactionFormController(),
      builder: (controller) {
        return Scaffold(
          appBar: StandardAppbar(
            title:
                controller.isEditMode ? 'Edit Transaksi' : 'Tambah Transaksi',
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
                        VText(
                          'Tipe',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 12),
                        _buildTypeSelector(controller),
                        const SizedBox(height: 24),
                        VFormInput(
                          label: 'Jumlah',
                          hint: 'Masukkan jumlah',
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedMoney01,
                              color: VColor.primary,
                            ),
                          ),
                          validator: controller.validateAmount,
                        ),
                        const SizedBox(height: 20),
                        VFormInput(
                          label: 'Deskripsi',
                          hint: 'Masukkan deskripsi',
                          controller: controller.descriptionController,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedFileEdit,
                              color: VColor.primary,
                            ),
                          ),
                          validator: controller.validateDescription,
                        ),
                        const SizedBox(height: 20),
                        VFormInput(
                          label: 'Kategori',
                          hint: 'Masukkan atau pilih kategori',
                          controller: controller.categoryController,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedTag01,
                              color: VColor.primary,
                            ),
                          ),
                          validator: controller.validateCategory,
                        ),
                        const SizedBox(height: 12),
                        _buildCategorySuggestions(controller),
                        const SizedBox(height: 24),
                        VText(
                          'Tanggal',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 12),
                        _buildDatePicker(context, controller),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          controller.isEditMode
                              ? 'Perbarui Transaksi'
                              : 'Tambah Transaksi',
                          onTap: () => _saveTransaction(
                            context,
                            formKey,
                            controller,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTypeSelector(TransactionFormController controller) {
    return Container(
      decoration: VStyle.boxShadow(radius: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeOption(
              controller,
              'Pemasukan',
              TransactionType.pemasukan,
              HugeIcons.strokeRoundedArrowUp01,
              Colors.green,
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: _buildTypeOption(
              controller,
              'Pengeluaran',
              TransactionType.pengeluaran,
              HugeIcons.strokeRoundedArrowDown01,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(
    TransactionFormController controller,
    String label,
    TransactionType type,
    dynamic icon,
    Color color,
  ) {
    final isSelected = controller.selectedType == type;

    return InkWell(
      onTap: () => controller.updateType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (color == Colors.green
                  ? const Color(0x1A4CAF50)
                  : const Color(0x1AFF5722))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            HugeIcon(
              icon: icon,
              color: isSelected ? color : VColor.greyText,
              size: 32,
            ),
            const SizedBox(height: 8),
            VText(
              label,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? color : VColor.greyText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySuggestions(TransactionFormController controller) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.suggestedCategories.map((category) {
        final isSelected = controller.categoryController.text == category;

        return InkWell(
          onTap: () {
            controller.categoryController.text = category;
            controller.update();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? VColor.primary : const Color(0x1A00786F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: VText(
              category,
              fontSize: 12,
              color: isSelected ? Colors.white : VColor.primary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker(
      BuildContext context, TransactionFormController controller) {
    return InkWell(
      onTap: () => _selectDate(context, controller),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: VStyle.boxShadow(radius: 12),
        child: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar03,
              color: VColor.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VText(
                    'Tanggal Transaksi',
                    fontSize: 12,
                    color: VColor.greyText,
                  ),
                  const SizedBox(height: 4),
                  VText(
                    DateFormat('EEEE, MMMM dd, yyyy')
                        .format(controller.selectedDate),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: 16,
              color: VColor.greyText,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TransactionFormController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: VColor.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: VColor.dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateDate(picked);
    }
  }

  Future<void> _saveTransaction(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TransactionFormController controller,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    VPopup.loading();
    final success = await controller.saveTransaction();
    VPopup.pop();

    if (success) {
      VToast.success(
        controller.isEditMode
            ? 'Transaksi berhasil diperbarui'
            : 'Transaksi berhasil ditambahkan',
      );
      Get.back(result: true);
    } else {
      VPopup.error(controller.error);
    }
  }
}
