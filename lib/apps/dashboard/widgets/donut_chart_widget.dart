import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DonutChartWidget extends StatelessWidget {
  const DonutChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Container(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Donut Chart
              CustomPaint(
                size: const Size(200, 200),
                painter: DonutChartPainter(
                  categoryData: controller.categoryData,
                  totalExpenses: controller.totalExpenses.value,
                ),
              ),
              // Center text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${_formatAmount(controller.totalExpenses.value)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_formatAmount(controller.balance.value)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatAmount(int amount) {
    return (amount / 1000).toStringAsFixed(1);
  }
}

class DonutChartPainter extends CustomPainter {
  final List<CategoryData> categoryData;
  final int totalExpenses;

  DonutChartPainter({
    required this.categoryData,
    required this.totalExpenses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (categoryData.isEmpty || totalExpenses == 0) {
      // Draw empty circle
      final paint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20;

      final center = Offset(size.width / 2, size.height / 2);
      final radius = (size.width - 40) / 2;

      canvas.drawCircle(center, radius, paint);
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 40) / 2;

    double startAngle = -90 * (3.14159 / 180); // Start from top

    for (int i = 0; i < categoryData.length; i++) {
      final category = categoryData[i];
      final sweepAngle = (category.amount / totalExpenses) * 2 * 3.14159;

      final paint = Paint()
        ..color = category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
