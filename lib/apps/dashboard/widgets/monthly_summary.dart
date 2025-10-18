import 'package:intl/intl.dart';

import '../../../base/export_view.dart';
import '../controllers/dashboard_controller.dart';

class MonthlySummary extends StatelessWidget {
  final DashboardController controller;

  const MonthlySummary({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(now);

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
            VText(
              'This Month - $monthName',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Income',
                amount: controller.monthlyIncome,
                icon: HugeIcons.strokeRoundedArrowUp01,
                color: Colors.green,
                bgColor: const Color(0x1A4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                label: 'Expenses',
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
                'Monthly Balance',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              VText(
                controller.monthlyBalance.formatCurrency,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    controller.monthlyBalance >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
      ],
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
