import '../../../base/export_view.dart';
import '../controllers/dashboard_controller.dart';

class BalanceCard extends StatelessWidget {
  final DashboardController controller;

  const BalanceCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final balance = controller.balance;
    final isPositive = balance >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPositive
              ? [const Color(0xFF00786F), const Color(0xFF009688)]
              : [const Color(0xFFFF5722), const Color(0xFFFF7043)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                isPositive ? const Color(0x4D00786F) : const Color(0x4DFF5252),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedWallet03,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              VText(
                'Total Balance',
                fontSize: 16,
                color: const Color(0xE6FFFFFF),
              ),
            ],
          ),
          const SizedBox(height: 16),
          VText(
            balance.formatCurrency,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: BalanceItem(
                  label: 'Income',
                  amount: controller.totalIncome,
                  icon: HugeIcons.strokeRoundedArrowUp01,
                  color: const Color(0xE6FFFFFF),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0x4DFFFFFF),
              ),
              Expanded(
                child: BalanceItem(
                  label: 'Expenses',
                  amount: controller.totalExpenses,
                  icon: HugeIcons.strokeRoundedArrowDown01,
                  color: const Color(0xE6FFFFFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BalanceItem extends StatelessWidget {
  final String label;
  final int amount;
  final dynamic icon;
  final Color color;

  const BalanceItem({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HugeIcon(
          icon: icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 8),
        VText(
          label,
          fontSize: 12,
          color: const Color(0xB3FFFFFF),
        ),
        const SizedBox(height: 4),
        VText(
          amount.formatCurrency,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ],
    );
  }
}
