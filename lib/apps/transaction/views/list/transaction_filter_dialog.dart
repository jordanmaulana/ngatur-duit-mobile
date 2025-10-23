import '../../../../base/export_view.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction.dart';

class TransactionFilterDialog extends StatelessWidget {
  final TransactionController controller;

  const TransactionFilterDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0x26FFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedFilterHorizontal,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  VText(
                    'Filter Transaksi',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            // Content
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type filter
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowDataTransferVertical,
                        color: VColor.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      VText(
                        'Tipe Transaksi',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTypeChip(
                        context,
                        label: 'Semua',
                        icon: HugeIcons.strokeRoundedViewOff,
                        isSelected: controller.selectedType == null,
                        onTap: () {
                          controller.filterByType(null);
                          Navigator.pop(context);
                        },
                      ),
                      _buildTypeChip(
                        context,
                        label: 'Pemasukan',
                        icon: HugeIcons.strokeRoundedArrowUp01,
                        color: Colors.green,
                        isSelected: controller.selectedType ==
                            TransactionType.pemasukan,
                        onTap: () {
                          controller.filterByType(TransactionType.pemasukan);
                          Navigator.pop(context);
                        },
                      ),
                      _buildTypeChip(
                        context,
                        label: 'Pengeluaran',
                        icon: HugeIcons.strokeRoundedArrowDown01,
                        color: Colors.red,
                        isSelected: controller.selectedType ==
                            TransactionType.pengeluaran,
                        onTap: () {
                          controller.filterByType(TransactionType.pengeluaran);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  // Category filter
                  if (controller.categories.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedTag01,
                          color: VColor.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        VText(
                          'Kategori',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildCategoryChip(
                          context,
                          category: 'Semua',
                          isSelected: controller.selectedCategory == null,
                          onTap: () {
                            controller.filterByCategory(null);
                            Navigator.pop(context);
                          },
                        ),
                        ...controller.categories.map((category) {
                          return _buildCategoryChip(
                            context,
                            category: category,
                            isSelected: controller.selectedCategory == category,
                            onTap: () {
                              controller.filterByCategory(category);
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Footer actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete02,
                      color: VColor.error,
                      size: 16,
                    ),
                    label: VText(
                      'Hapus Semua',
                      color: VColor.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: VText(
                      'Tutup',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context, {
    required String label,
    required dynamic icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? VColor.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? chipColor : const Color(0xFFE0E0E0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: icon,
              color: isSelected ? Colors.white : chipColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            VText(
              label,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : VColor.dark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    VColor.primary,
                    Color(0xCC00786F),
                  ],
                )
              : null,
          color: isSelected ? null : const Color(0x1A00786F),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0x4D00786F),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: VText(
          category,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? Colors.white : VColor.primary,
        ),
      ),
    );
  }

  static void show(BuildContext context, TransactionController controller) {
    showDialog(
      context: context,
      builder: (context) => TransactionFilterDialog(controller: controller),
    );
  }
}
