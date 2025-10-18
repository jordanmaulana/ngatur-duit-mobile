import 'package:flutter/material.dart';
import 'package:flutter_usecase_template/apps/dashboard/views/month_selector.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/action_buttons_widget.dart';
import '../widgets/balance_display_widget.dart';
import '../widgets/category_icons_widget.dart';
import '../widgets/donut_chart_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF2E7D6B), // Dark teal background
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedMenu01,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Text(
                            'Ngatur Duit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'All accounts',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedMoreVertical,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const MonthSelector(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              // Chart section
                              Expanded(
                                flex: 3,
                                child: _buildChartSection(controller),
                              ),

                              // Balance display
                              _buildBalanceSection(),

                              // Action buttons
                              const ActionButtonsWidget(),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartSection(DashboardController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Category icons around the chart
          const CategoryIconsWidget(),

          // Donut chart in the center
          const DonutChartWidget(),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: BalanceDisplayWidget(),
    );
  }
}
