import '../../../base/export_view.dart';
import '../../transaction/views/add/transaction_form_page.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/top_categories.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
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
      body: RefreshIndicator(
        onRefresh: () => controller.loadDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(),
              const SizedBox(height: 20),
              MonthlySummary(),
              const SizedBox(height: 24),
              TopCategories(),
              const SizedBox(height: 24),
              RecentTransactions(),
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
  }
}
