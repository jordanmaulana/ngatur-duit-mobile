import '../../../../base/export_view.dart';
import '../../controllers/transaction_controller.dart';

class TransactionSummaryCard extends StatelessWidget {
  const TransactionSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      builder: (controller) {
        final income = controller.getTotalIncome();
        final expenses = controller.getTotalExpenses();
        final balance = controller.getBalance();
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: VStyle.boxShadow(radius: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SummaryItem(
                    label: 'Pemasukan',
                    amount: income,
                    color: Colors.green,
                  ),
                  _SummaryItem(
                    label: 'Pengeluaran',
                    amount: expenses,
                    color: Colors.red,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VText(
                    'Saldo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  VText(
                    balance.formatCurrency,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VText(label, fontSize: 13, color: VColor.greyText),
        const SizedBox(height: 2),
        VText(
          amount.formatCurrency,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ],
    );
  }
}
