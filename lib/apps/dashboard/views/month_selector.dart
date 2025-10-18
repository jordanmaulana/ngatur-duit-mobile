import 'package:flutter_usecase_template/apps/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter_usecase_template/base/export_view.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GetBuilder(
        builder: (DashboardController controller) {
          return VText(
            controller.selectedMonth.value,
            color: VColor.white,
          );
        },
      ),
    );
  }
}
