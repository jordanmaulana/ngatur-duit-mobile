import 'package:intl/intl.dart';

import '../../../base/export_view.dart';
import '../controllers/dashboard_controller.dart';
import '../../transaction/models/transaction.dart';
import '../../transaction/views/list/transaction_list_page.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (DashboardController controller) {
        if (controller.recentTransactions.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VText(
                  'Transaksi Terbaru',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                InkWell(
                  onTap: () => Get.to(() => const TransactionListPage()),
                  child: VText(
                    'Lihat Semua',
                    fontSize: 13,
                    color: VColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...controller.recentTransactions.map(
              (transaction) {
                final isExpense =
                    transaction.type == TransactionType.pengeluaran;
                final color = isExpense ? Colors.red : Colors.green;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: VStyle.boxShadow(radius: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isExpense
                              ? const Color(0x1AFF0000)
                              : const Color(0x1A00FF00),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: HugeIcon(
                          icon: isExpense
                              ? HugeIcons.strokeRoundedArrowDown01
                              : HugeIcons.strokeRoundedArrowUp01,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VText(
                              transaction.description ?? 'Tidak ada deskripsi',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (transaction.category != null) ...[
                                  VText(
                                    transaction.category!,
                                    fontSize: 12,
                                    color: VColor.greyText,
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      color: VColor.greyText,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                VText(
                                  DateFormat('MMM dd').format(transaction.date),
                                  fontSize: 12,
                                  color: VColor.greyText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      VText(
                        '${isExpense ? '-' : '+'} ${transaction.amount.formatCurrency}',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
