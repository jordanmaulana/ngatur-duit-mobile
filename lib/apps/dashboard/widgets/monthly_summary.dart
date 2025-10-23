import 'package:intl/intl.dart';

import '../../../base/export_view.dart';
import '../controllers/dashboard_controller.dart';

class MonthlySummary extends StatelessWidget {
  const MonthlySummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        final monthName =
            DateFormat('MMMM yyyy').format(controller.selectedMonth);
        final isCurrentMonth =
            controller.selectedMonth.year == DateTime.now().year &&
                controller.selectedMonth.month == DateTime.now().month;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  color: VColor.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: VText(
                    isCurrentMonth ? 'Bulan Ini - $monthName' : monthName,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () => controller.previousMonth(),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: VColor.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: isCurrentMonth ? null : () => controller.nextMonth(),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      color: isCurrentMonth ? VColor.greyText : VColor.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: isCurrentMonth
                      ? null
                      : () => controller.resetToCurrentMonth(),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrentMonth
                          ? const Color(0x1AE0E0E0)
                          : const Color(0x1A00786F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedHome01,
                      color: isCurrentMonth ? VColor.greyText : VColor.primary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    label: 'Pemasukan',
                    amount: controller.monthlyIncome,
                    icon: HugeIcons.strokeRoundedArrowUp01,
                    color: Colors.green,
                    bgColor: const Color(0x1A4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    label: 'Pengeluaran',
                    amount: controller.monthlyExpenses,
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    color: Colors.red,
                    bgColor: const Color(0x1AFF5722),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: VStyle.boxShadow(radius: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VText(
                    'Saldo Bulanan',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  VText(
                    controller.monthlyBalance.formatCurrency,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: controller.monthlyBalance >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final int amount;
  final dynamic icon;
  final Color color;
  final Color bgColor;

  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: VStyle.boxShadow(radius: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: HugeIcon(
              icon: icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          VText(
            label,
            fontSize: 12,
            color: VColor.greyText,
          ),
          const SizedBox(height: 4),
          VText(
            amount.formatCurrency,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ],
      ),
    );
  }
}
