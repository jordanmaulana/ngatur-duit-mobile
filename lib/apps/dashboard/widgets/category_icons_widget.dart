import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class CategoryIconsWidget extends StatelessWidget {
  const CategoryIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        if (controller.categoryData.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            children: [
              // Position category icons around the donut chart
              ...controller.categoryData.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return _buildCategoryIcon(
                  category: category,
                  index: index,
                  totalItems: controller.categoryData.length,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon({
    required CategoryData category,
    required int index,
    required int totalItems,
  }) {
    // Calculate position around the circle
    final angle =
        (index * 2 * 3.14159 / totalItems) - (3.14159 / 2); // Start from top
    final radius = 120.0;

    final x = 140 + radius * cos(angle);
    final y = 140 + radius * sin(angle);

    return Positioned(
      left: x - 20,
      top: y - 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A000000),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getMaterialIcon(category.icon),
              color: category.color,
              size: 20,
            ),
          ),
          if (category.percentage > 5) // Only show percentage if significant
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  category.color.withAlpha(26),
                  Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${category.percentage}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: category.color,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getMaterialIcon(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'car':
        return Icons.directions_car;
      case 'utensils':
        return Icons.restaurant;
      case 'shopping-bag':
        return Icons.shopping_bag;
      case 'heart-pulse':
        return Icons.favorite;
      case 'gamepad2':
        return Icons.sports_esports;
      case 'shirt':
        return Icons.checkroom;
      case 'cat':
        return Icons.pets;
      case 'phone':
        return Icons.phone;
      case 'gift':
        return Icons.card_giftcard;
      case 'train':
        return Icons.train;
      case 'taxi':
        return Icons.local_taxi;
      case 'thermometer':
        return Icons.thermostat;
      case 'toothbrush':
        return Icons.health_and_safety;
      case 'cocktail':
        return Icons.local_bar;
      case 'gymnastics':
        return Icons.sports_gymnastics;
      default:
        return Icons.circle;
    }
  }
}

double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);
