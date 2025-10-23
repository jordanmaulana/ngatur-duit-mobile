import 'package:intl/intl.dart';

import '../../../../base/export_view.dart';
import '../../../../ui/components/popup.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction.dart';
import '../add/transaction_form_page.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionController controller;
  final VoidCallback onDeleted;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.controller,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.pengeluaran;
    final color = isExpense ? Colors.red : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToForm(context),
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
                      transaction.description ?? 'Tidak ada deskripsi',
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
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    VPopup.proceedWarning(
      title: 'Hapus Transaksi',
      message: 'Apakah Anda yakin ingin menghapus transaksi ini?',
      callback: () async {
        VPopup.loading();
        final success = await controller.deleteTransaction(transaction.id);
        VPopup.pop();

        if (success) {
          onDeleted();
          VPopup.pop();
        } else {
          VPopup.error(controller.error);
        }
      },
    );
  }

  void _navigateToForm(BuildContext context) async {
    final result = await Get.to(
      () => const TransactionFormPage(),
      arguments: transaction,
    );

    if (result == true) {
      controller.loadTransactions();
    }
  }
}
