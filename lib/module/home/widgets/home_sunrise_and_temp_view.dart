import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_size.dart';
import '../../../utils/apps_color.dart';
import '../home_logic.dart';

class HomeSunriseAndSunsetView extends GetView<HomeLogic> {
  const HomeSunriseAndSunsetView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Get.isDarkMode ? AppsColor.white : const Color(0xFF1E2432);
    final titleTextColor = Get.isDarkMode ? AppsColor.white : const Color(0xFF1E2432);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(WSizes.defaultSpacing + 4),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppsColor.darkerGrey.withValues(alpha: 0.5) : AppsColor.white,
        borderRadius: BorderRadius.circular(WSizes.borderRadiusMd),
        border: Border.all(color: AppsColor.darkGrey.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Obx(() {
        final hasData = controller.weatherList.isNotEmpty && !controller.isLoading.value;
        final weather = hasData ? controller.weatherList.first : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUNRISE & SUNSET',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: titleTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSunTime('Sunrise', weather?.formattedSunrise ?? '06:25 AM'),
                _buildSunTime('Sunset', weather?.formattedSunset ?? '08:30 PM', isRight: true)
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              width: double.infinity,
              child: CustomPaint(painter: SunPathPainter()),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xFF8A90A2), fontSize: 12),
                children: [
                  const TextSpan(text: 'Length of day: '),
                  TextSpan(
                    text: weather?.lengthOfDay ?? '13H 12M',
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xFF8A90A2), fontSize: 12),
                children: [
                  const TextSpan(text: 'Remaining daylight: '),
                  TextSpan(
                    text: weather?.remainingDaylight ?? '9H 22M',
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  static Widget _buildSunTime(String label, String time, {bool isRight = false}) {
    return Column(
      crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppsColor.darkGrey, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
              color: Get.isDarkMode ? AppsColor.white : AppsColor.darkGrey,
              fontSize: 13,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}

class SunPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFF76C5F0)
      ..style = PaintingStyle.fill;

    final paintNight = Paint()
      ..color = const Color(0xFF092A6D)
      ..style = PaintingStyle.fill;

    final baseLinePaint = Paint()
      ..color = const Color(0xFFD3D8E2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double horizonY = size.height * 0.75;

    canvas.drawLine(Offset(0, horizonY), Offset(size.width, horizonY), baseLinePaint);

    final dayPath = Path()
      ..moveTo(size.width * 0.2, horizonY)
      ..quadraticBezierTo(size.width * 0.55, -5, size.width * 0.85, horizonY)
      ..close();

    final nightPath = Path()
      ..moveTo(0, horizonY)
      ..quadraticBezierTo(size.width * 0.1, size.height + 5, size.width * 0.2, horizonY)
      ..close();

    canvas.drawPath(dayPath, paintFill);
    canvas.drawPath(nightPath, paintNight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}