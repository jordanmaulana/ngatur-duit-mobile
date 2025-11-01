import '../../../base/export_view.dart';
import '../controllers/dashboard_controller.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        builder: (DashboardController controller) {
      final balance = controller.balance;
      final isPositive = balance >= 0;
      return Column(
        children: [
          // Total Balance Card (Compact)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isPositive
                    ? [const Color(0xFF00786F), const Color(0xFF009688)]
                    : [const Color(0xFFFF5722), const Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isPositive
                      ? const Color(0x4D00786F)
                      : const Color(0x4DFF5252),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedWallet03,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        VText(
                          'Total Saldo',
                          fontSize: 13,
                          color: const Color(0xE6FFFFFF),
                        ),
                      ],
                    ),
                    VText(
                      balance.formatCurrency,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _CompactBalanceItem(
                        label: 'Pemasukan',
                        amount: controller.totalIncome,
                        icon: HugeIcons.strokeRoundedArrowUp01,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _CompactBalanceItem(
                        label: 'Pengeluaran',
                        amount: controller.totalExpenses,
                        icon: HugeIcons.strokeRoundedArrowDown01,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Wallet Balances
          if (controller.wallets.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...controller.wallets.map((wallet) {
              final walletBalance = controller.walletBalances[wallet.id];
              if (walletBalance == null) return const SizedBox.shrink();

              final isPositive = walletBalance.balance >= 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x1A00786F),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0x1A00786F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedWallet03,
                        color: VColor.primary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VText(
                            wallet.name,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: VColor.primary,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowUp01,
                                color: Colors.green,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              VText(
                                walletBalance.income.formatCurrency,
                                fontSize: 10,
                                color: VColor.greyText,
                              ),
                              const SizedBox(width: 8),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowDown01,
                                color: Colors.red,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              VText(
                                walletBalance.expenses.formatCurrency,
                                fontSize: 10,
                                color: VColor.greyText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VText(
                      walletBalance.balance.formatCurrency,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      );
    });
  }
}

class _CompactBalanceItem extends StatelessWidget {
  final String label;
  final int amount;
  final dynamic icon;

  const _CompactBalanceItem({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VText(
                  label,
                  fontSize: 10,
                  color: const Color(0xB3FFFFFF),
                ),
                VText(
                  amount.formatCurrency,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
