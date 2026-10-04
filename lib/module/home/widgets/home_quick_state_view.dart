import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_size.dart';
import '../../../utils/apps_color.dart';
import '../home_logic.dart';

TextStyle _style(BuildContext context, double size, {bool sub = false, Color? color}) {
  final base = Theme.of(context).colorScheme.onSurface;
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color ?? (sub ? base.withValues(alpha: 0.6) : base),
  );
}
class HomeQuickStateView extends GetView<HomeLogic> {
  const HomeQuickStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: WSizes.defaultSpacing,
        horizontal: WSizes.defaultSpacing - 6,
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppsColor.darkerGrey.withValues(alpha: 0.5) : AppsColor.white,
        borderRadius: BorderRadius.circular(WSizes.borderRadiusMd),
        border: Border.all(color: AppsColor.darkGrey.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (controller.weatherList.isEmpty) return const SizedBox.shrink();
        final weather = controller.weatherList.first;
        final wind = weather.windSpeed.toStringAsFixed(1);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat(
              icon: Icons.access_time_rounded,
              label: 'TIME',
              value: weather.formattedLocalTime,
            ),
            _Stat(
              icon: Icons.air,
              label: 'WIND',
              value: '$wind m/s',
            ),
            _Stat(
              icon: Icons.umbrella_outlined,
              label: 'RAIN',
              value: '${weather.clouds}%',
            ),
            _Stat(
              icon: Icons.water_drop_outlined,
              label: 'HUMIDITY',
              value: '${weather.humidity}%',
            ),
            _Stat(
              icon: Icons.speed,
              label: 'pressure',
              value: '${weather.pressure}hPa',
            ),
          ],
        );
      }),
    );
  }
}
class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {

    final accentColor = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: WSizes.iconSm, color: accentColor),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: _style(context, 12)),
          ),
          const SizedBox(height: 2),
          Text(label, style: _style(context, 10, sub: true)),
        ],
      ),
    );
  }
}
