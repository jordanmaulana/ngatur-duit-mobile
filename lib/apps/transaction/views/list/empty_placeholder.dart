import '../../../../base/export_view.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Belum ada transaksi',
          fontSize: 18,
          color: VColor.greyText,
        ),
        const SizedBox(height: 8),
        VText(
          'Ketuk tombol + untuk menambah transaksi',
          fontSize: 14,
          color: VColor.greyText,
        ),
      ],
    );
  }
}
