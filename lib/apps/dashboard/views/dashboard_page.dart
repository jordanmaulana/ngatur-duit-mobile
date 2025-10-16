import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                // Header
                _buildHeader(),

                // Month selector
                _buildMonthSelector(controller),

                // Main content
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Hamburger menu
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          // App title
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

          // Action buttons
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(DashboardController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        controller.selectedMonth.value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
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
