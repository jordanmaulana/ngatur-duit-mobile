import 'package:ngatur_duit_mobile/apps/dashboard/views/dashboard_page.dart';
import 'package:ngatur_duit_mobile/apps/profile/views/main/coming_soon.dart';

import 'package:ngatur_duit_mobile/apps/transaction/views/list/transaction_list_page.dart';
import 'package:ngatur_duit_mobile/apps/wallet/views/wallet_list_page.dart';

import '../../../base/export_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavPage extends StatelessWidget {
  const MainNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainNavController controller = Get.put(MainNavController());

    return Obx(() {
      return Scaffold(
        body: Builder(
          builder: (context) {
            switch (controller.index.value) {
              case 0:
                return const DashboardPage();
              case 1:
                return const TransactionListPage();
              case 2:
                return const WalletListPage();
              case 3:
                return const ComingSoonPage();
            }
            return Container();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: VColor.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.index.value,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0.0,
          onTap: (v) => controller.setIndex(v),
          items: [
            BottomNavigationBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedHome01,
                color: controller.index.value == 0
                    ? VColor.primary
                    : VColor.accent,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedInvoice01,
                color: controller.index.value == 1
                    ? VColor.primary
                    : VColor.accent,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedWallet01,
                color: controller.index.value == 3
                    ? VColor.primary
                    : VColor.accent,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                color: controller.index.value == 2
                    ? VColor.primary
                    : VColor.accent,
              ),
              label: '',
            ),
          ],
        ),
      );
    });
  }
}
