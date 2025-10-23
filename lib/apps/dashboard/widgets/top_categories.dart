import '../../../base/export_view.dart';
import '../controllers/dashboard_controller.dart';
import '../../transaction/models/transaction.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        builder: (DashboardController controller) {
      if (controller.topExpenseCategories.isEmpty &&
          controller.topIncomeCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VText(
            'Kategori Teratas',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),
          if (controller.topExpenseCategories.isNotEmpty) ...[
            CategorySection(
              title: 'Pengeluaran Teratas',
              categories: controller.topExpenseCategories,
              type: TransactionType.pengeluaran,
            ),
            const SizedBox(height: 16),
          ],
          if (controller.topIncomeCategories.isNotEmpty)
            CategorySection(
              title: 'Sumber Pemasukan Teratas',
              categories: controller.topIncomeCategories,
              type: TransactionType.pemasukan,
            ),
        ],
      );
    });
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<CategorySummary> categories;
  final TransactionType type;

  const CategorySection({
    super.key,
    required this.title,
    required this.categories,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        type == TransactionType.pengeluaran ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: VStyle.boxShadow(radius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: type == TransactionType.pengeluaran
                    ? HugeIcons.strokeRoundedArrowDown01
                    : HugeIcons.strokeRoundedArrowUp01,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              VText(
                title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...categories.map(
            (cat) {
              return GetBuilder<DashboardController>(
                builder: (DashboardController controller) {
                  final percentage =
                      controller.getCategoryPercentage(cat.amount, type);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            VText(
                              cat.category,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            VText(
                              cat.amount.formatCurrency,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0x1A72678A),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: percentage / 100,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
