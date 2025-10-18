import '../../../base/export_view.dart';
import '../../../ui/components/app_bar.dart';
import '../../../ui/components/loadings.dart';
import '../../transaction/views/add/transaction_form_page.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/top_categories.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          appBar: StandardAppbar(
            title: 'Dashboard',
            includeBackButton: false,
          ),
          body: controller.loading
              ? const VLoading()
              : RefreshIndicator(
                  onRefresh: () => controller.loadDashboardData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BalanceCard(controller: controller),
                        const SizedBox(height: 20),
                        MonthlySummary(controller: controller),
                        const SizedBox(height: 24),
                        TopCategories(controller: controller),
                        const SizedBox(height: 24),
                        RecentTransactions(controller: controller),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Get.to(() => const TransactionFormPage());
              if (result == true) {
                controller.loadDashboardData();
              }
            },
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
}
