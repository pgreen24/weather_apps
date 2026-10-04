import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_apps/module/home/home_logic.dart';

const _accent = Colors.blueAccent;

class HomeDailyForecast extends StatefulWidget {
  const HomeDailyForecast({super.key});

  @override
  State<HomeDailyForecast> createState() => _HomeDailyForecastState();
}

class _HomeDailyForecastState extends State<HomeDailyForecast> {
  final controller = Get.find<HomeLogic>();
  bool _expanded = false;

  String _dayTitle(String date) {
    try {
      final parsed = DateTime.parse(date);
      final now = DateTime.now();
      final diff = DateTime(parsed.year, parsed.month, parsed.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Tomorrow';
      return DateFormat('EEEE').format(parsed);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hourlyForecastList.isEmpty) return const SizedBox.shrink();
      final selected = controller.selectedForecastDate.value;

      final days = <String, List<Map>>{};
      for (final block in controller.hourlyForecastList) {
        final text = '${block['dt_txt'] ?? ''}';
        if (text.length >= 10) {
          (days[text.substring(0, 10)] ??= []).add(block as Map);
        }
      }
      final dates = days.keys.toList()..sort();
      final shown = _expanded ? dates : dates.take(2).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Forecast',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'Show Less' : 'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _accent.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _accent.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < shown.length; i++) ...[
                    if (i > 0)
                      Divider(color: _accent.withValues(alpha: 0.1), height: 20),
                    _DayRow(
                      title: _dayTitle(shown[i]),
                      blocks: days[shown[i]]!,
                      isSelected: shown[i] == selected,
                      onTap: () => controller.selectedForecastDate.value = shown[i],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.title,
    required this.blocks,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final List<Map> blocks;
  final bool isSelected;
  final VoidCallback onTap;

  double _extreme(String key, double Function(double, double) pick) => blocks
      .map((b) => (b['main']?[key] as num?)?.toDouble() ?? 0.0)
      .reduce(pick);

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurface;
    final muted = base.withValues(alpha: 0.6);

    final list = blocks.first['weather'] as List?;
    final weather = list != null && list.isNotEmpty ? list[0] : null;
    final status = '${weather?['main'] ?? 'Clear'}';
    final iconPath = Get.find<HomeLogic>().getWeatherIcon('${weather?['icon'] ?? '01d'}');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? _accent.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 85,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? _accent : base,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              iconPath,
              height: 25,
              width: 25,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.wb_sunny_rounded, color: Colors.orangeAccent, size: 22),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? _accent.withValues(alpha: 0.8) : muted,
                ),
              ),
            ),
            SizedBox(
              width: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${_extreme('temp_max', math.max).round()}°',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? _accent : base,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_extreme('temp_min', math.min).round()}°',
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? _accent.withValues(alpha: 0.6) : muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
