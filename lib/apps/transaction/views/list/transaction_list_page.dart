import '../../../../base/export_view.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction.dart';
import 'empty_placeholder.dart';
import 'transaction_filter_dialog.dart';
import 'transaction_item.dart';
import 'transaction_summary_card.dart';
import '../add/transaction_form_page.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      builder: (TransactionController controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: VColor.primary,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    VColor.primary,
                    Color(0xCC00786F),
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedInvoice,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                VText(
                  'Transaksi',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedFilterHorizontal,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () =>
                    TransactionFilterDialog.show(context, controller),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: Column(
            children: [
              if (!controller.loading &&
                  controller.error.isEmpty &&
                  controller.filteredTransactions.isNotEmpty)
                TransactionSummaryCard(),
              Expanded(
                child: controller.loading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.error.isNotEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedAlert02,
                                    size: 48,
                                    color: VColor.error,
                                  ),
                                  const SizedBox(height: 16),
                                  VText(
                                    controller.error,
                                    color: VColor.error,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : controller.filteredTransactions.isEmpty
                            ? const EmptyPlaceholder()
                            : RefreshIndicator(
                                onRefresh: () => controller.loadTransactions(),
                                child: ListView.separated(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 80),
                                  itemCount:
                                      controller.filteredTransactions.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        controller.filteredTransactions[index];
                                    return TransactionItem(
                                      transaction: transaction,
                                      onDeleted: () => VToast.success(
                                          'Transaksi berhasil dihapus'),
                                    );
                                  },
                                ),
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
