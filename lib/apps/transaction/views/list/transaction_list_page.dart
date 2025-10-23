import '../../../../base/export_view.dart';
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
      builder: (controller) {
        return Scaffold(
          appBar: StandardAppbar(
            title: 'Transaksi',
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
          body: VList(
            loading: controller.loading,
            errorMsg: controller.error,
            length: controller.filteredTransactions.length,
            onRefresh: () => controller.loadTransactions(),
            emptyPlaceHolder: const EmptyPlaceholder(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separator: const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final transaction = controller.filteredTransactions[index];
              return TransactionItem(
                transaction: transaction,
                onDeleted: () => VToast.success('Transaksi berhasil dihapus'),
              );
            },
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
