import '../../../base/export_view.dart';
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
          backgroundColor: Colors.grey[50],
          body: controller.loading
              ? const VLoading()
              : CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 120,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: VColor.primary,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(
                          left: 20,
                          bottom: 16,
                        ),
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0x26FFFFFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const HugeIcon(
                                icon: HugeIcons.strokeRoundedWallet03,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            VText(
                              'Ngatur Duit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                VColor.primary,
                                const Color(0xCC00786F),
                              ],
                            ),
                          ),
                        ),
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
                              icon: HugeIcons.strokeRoundedRefresh,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onPressed: () => controller.loadDashboardData(),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: RefreshIndicator(
                        onRefresh: () => controller.loadDashboardData(),
                        child: Padding(
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
                    ),
                  ],
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
