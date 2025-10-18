import 'package:intl/intl.dart';

import '../../../../base/export_view.dart';
import '../../../../ui/components/app_bar.dart';
import '../../../../ui/components/lists.dart';
import '../../../../ui/components/popup.dart';
import '../../../../ui/components/toast.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction.dart';
import 'transaction_filter_dialog.dart';
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
                  emptyPlaceHolder: _buildEmptyView(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separator: const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final transaction = controller.filteredTransactions[index];
                    return _buildTransactionCard(
                        context, transaction, controller);
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

  Widget _buildTransactionCard(
    BuildContext context,
    Transaction transaction,
    TransactionController controller,
  ) {
    final isExpense = transaction.type == TransactionType.pengeluaran;
    final color = isExpense ? Colors.red : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () =>
            _navigateToForm(context, controller, transaction: transaction),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
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

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VText(
                      transaction.description ?? 'No description',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (transaction.category != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x1A00786F),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: VText(
                              transaction.category!,
                              fontSize: 12,
                              color: VColor.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        VText(
                          DateFormat('MMM dd, yyyy').format(transaction.date),
                          fontSize: 12,
                          color: VColor.greyText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount and actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  VText(
                    '${isExpense ? '-' : '+'} ${transaction.amount.formatCurrency}',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete02,
                      color: VColor.error,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () =>
                        _confirmDelete(context, transaction, controller),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedInvoice,
          size: 80,
          color: Color(0x8072678A),
        ),
        const SizedBox(height: 16),
        VText(
          'No transactions yet',
          fontSize: 18,
          color: VColor.greyText,
        ),
        const SizedBox(height: 8),
        VText(
          'Tap the + button to add a transaction',
          fontSize: 14,
          color: VColor.greyText,
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, Transaction transaction,
      TransactionController controller) {
    VPopup.proceedWarning(
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete this transaction?',
      callback: () async {
        VPopup.loading();
        final success = await controller.deleteTransaction(transaction.id);
        VPopup.pop();

        if (success) {
          VToast.success('Transaction deleted successfully');
        } else {
          VPopup.error(controller.error);
        }
      },
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
