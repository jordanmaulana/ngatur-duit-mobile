import '../../../../base/export_view.dart';
import '../../../../ui/components/app_bar.dart';
import '../../../../ui/components/lists.dart';
import '../../../../ui/components/toast.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction.dart';
import 'empty_placeholder.dart';
import 'transaction_filter_dialog.dart';
import 'transaction_item.dart';
import '../add/transaction_form_page.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      init: TransactionController(),
      builder: (controller) {
        return Scaffold(
          appBar: StandardAppbar(
            title: 'Transactions',
            includeBackButton: true,
            actions: [
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedFilterHorizontal,
                  color: VColor.dark,
                ),
                onPressed: () =>
                    TransactionFilterDialog.show(context, controller),
              ),
            ],
          ),
          body: Column(
            children: [
              if (!controller.loading &&
                  controller.error.isEmpty &&
                  controller.filteredTransactions.isNotEmpty)
                _buildSummaryCard(controller),
              Expanded(
                child: VList(
                  loading: controller.loading,
                  errorMsg: controller.error,
                  length: controller.filteredTransactions.length,
                  onRefresh: () => controller.loadTransactions(),
                  emptyPlaceHolder: const EmptyPlaceholder(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separator: const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final transaction = controller.filteredTransactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      controller: controller,
                      onDeleted: () =>
                          VToast.success('Transaction deleted successfully'),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToForm(context, controller),
            backgroundColor: VColor.primary,
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(TransactionController controller) {
    final income = controller.getTotalIncome();
    final expenses = controller.getTotalExpenses();
    final balance = controller.getBalance();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: VStyle.boxShadow(radius: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Income',
                income,
                Colors.green,
              ),
              _buildSummaryItem(
                'Expenses',
                expenses,
                Colors.red,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VText(
                'Balance',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              VText(
                balance.formatCurrency,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VText(label, fontSize: 14, color: VColor.greyText),
        const SizedBox(height: 4),
        VText(
          amount.formatCurrency,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ],
    );
  }

  void _navigateToForm(BuildContext context, TransactionController controller,
      {Transaction? transaction}) async {
    final result = await Get.to(
      () => const TransactionFormPage(),
      arguments: transaction,
    );

    if (result == true) {
      controller.loadTransactions();
    }
  }
}
