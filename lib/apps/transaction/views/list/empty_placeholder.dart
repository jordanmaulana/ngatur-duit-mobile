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
}
