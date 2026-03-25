import '../../../base/export_view.dart';
import '../controllers/wallet_controller.dart';

class WalletBalanceInfo extends StatelessWidget {
  final WalletBalance walletBalance;
  const WalletBalanceInfo({required this.walletBalance, super.key});

  @override
  Widget build(BuildContext context) {
    final isPositive = walletBalance.balance >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        VText(
          walletBalance.balance.formatCurrency,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isPositive ? Colors.green : Colors.red,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowUp01,
              color: Colors.green,
              size: 12,
            ),
            SizedBox(width: 2),
            VText(
              walletBalance.income.formatCurrency,
              fontSize: 10,
              color: VColor.greyText,
            ),
          ],
        ),
        SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: Colors.red,
              size: 12,
            ),
            SizedBox(width: 2),
            VText(
              walletBalance.expenses.formatCurrency,
              fontSize: 10,
              color: VColor.greyText,
            ),
          ],
        ),
      ],
    );
  }
}
