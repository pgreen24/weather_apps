import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_apps/module/home/home_logic.dart';
import 'package:weather_apps/utils/app_size.dart';

const _accent = Colors.blueAccent;
extension _Hour on Map {
  double get temp => (this['main']?['temp'] as num?)?.toDouble() ?? 0;

  String get icon {
    final list = this['weather'] as List?;
    return list != null && list.isNotEmpty ? list[0]['icon'] ?? '' : '';
  }

  String time(String format) {
    try {
      return DateFormat(format).format(DateTime.parse(this['dt_txt']));
    } catch (_) {
      return '--';
    }
  }
}

TextStyle _style(BuildContext context, double size, {bool sub = false, Color? color}) {
  final base = Theme.of(context).colorScheme.onSurface;
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color ?? (sub ? base.withValues(alpha: 0.6) : base),
  );
}

class HomeHourlyForecast extends StatefulWidget {
  const HomeHourlyForecast({super.key});

  @override
  State<HomeHourlyForecast> createState() => _HomeHourlyForecastState();
}

class _HomeHourlyForecastState extends State<HomeHourlyForecast> {
  final controller = Get.find<HomeLogic>();
  int _selected = 0;
  String _lastDate = '';

  void _select(int index, int length) {
    if (index >= 0 && index < length && index != _selected) {
      setState(() => _selected = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hourlyForecastList.isEmpty) return const SizedBox.shrink();

      final date = controller.selectedForecastDate.value;
      if (date != _lastDate) {
        _lastDate = date;
        _selected = 0;
      }

      final all = controller.hourlyForecastList.map<Map>((b) => b as Map).toList();
      final sameDay = all.where((b) => '${b['dt_txt']}'.startsWith(date)).toList();
      final data = (sameDay.isNotEmpty ? sameDay : all).take(8).toList();
      if (_selected >= data.length) _selected = 0;

      var title = 'Hourly Forecast';
      try {
        title += ' (${DateFormat('dd MMM').format(DateTime.parse(date))})';
      } catch (_) {}

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            child: Text(title, style: _style(context, 16)),
          ),
          _HourChart(
            data: data,
            selected: _selected,
            onSelect: (i) => _select(i, data.length),
          ),
          const SizedBox(height: WSizes.xs),
          Row(children: [
            for (var i = 0; i < data.length; i++)
              _HourCard(
                block: data[i],
                isSelected: i == _selected,
                onTap: () => _select(i, data.length),
              ),
          ]),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _DetailPanel(key: ValueKey(_selected), block: data[_selected]),
          ),
        ],
      );
    });
  }
}

class _HourChart extends StatelessWidget {
  const _HourChart({required this.data, required this.selected, required this.onSelect});

  final List<Map> data;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final temps = data.map((b) => b.temp).toList()..sort();
    final flat = temps.first == temps.last;
    final spots = [
      for (var i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i].temp),
    ];

    return SizedBox(
      height: 160,
      child: LineChart(LineChartData(
        minX: -0.5,
        maxX: data.length - 0.5,
        minY: temps.first - (flat ? 5 : 3),
        maxY: temps.last + (flat ? 5 : 3),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(verticalLines: [
          VerticalLine(
            x: selected.toDouble(),
            color: _accent.withValues(alpha: 0.5),
            strokeWidth: 1.5,
            dashArray: [4, 4],
          ),
        ]),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchSpotThreshold: 40,
          touchCallback: (event, response) {
            final touched = response?.lineBarSpots;
            final isTouch = event is FlTapUpEvent ||
                event is FlTapDownEvent ||
                event is FlPanDownEvent ||
                event is FlPanUpdateEvent;
            if (isTouch && touched != null && touched.isNotEmpty) {
              onSelect(touched.first.spotIndex);
            }
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            preventCurveOverShooting: true,
            color: _accent,
            barWidth: 4,
            dotData: FlDotData(
              getDotPainter: (spot, _, __, i) => FlDotCirclePainter(
                radius: i == selected ? 8 : 5,
                color: i == selected ? _accent : bg,
                strokeWidth: i == selected ? 4 : 2.5,
                strokeColor: i == selected ? bg : _accent,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [_accent.withValues(alpha: 0.3), _accent.withValues(alpha: 0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class _HourCard extends StatelessWidget {
  const _HourCard({required this.block, required this.isSelected, required this.onTap});

  final Map block;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final white = isSelected ? Colors.white : null;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: isSelected ? _accent : _accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(block.time('h a'), style: _style(context, 10, sub: true, color: white)),
            ),
            const SizedBox(height: WSizes.xs),
            _WeatherIcon(block, size: 26, fallback: white ?? Colors.orangeAccent),
            const SizedBox(height: WSizes.xs),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('${block.temp.round()}°', style: _style(context, 13, color: white)),
            ),
          ]),
        ),
      ),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({super.key, required this.block});

  final Map block;

  @override
  Widget build(BuildContext context) {
    final main = block['main'] as Map?;
    final weather = block['weather'] as List?;
    final wind = (block['wind']?['speed'] as num?)?.toStringAsFixed(1);
    final rain = (((block['pop'] as num?) ?? 0) * 100).round();
    final text = weather != null && weather.isNotEmpty ? '${weather[0]['description']}' : '';
    String value(num? v, String unit) => v == null ? '--' : '${v.round()}$unit';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(WSizes.borderRadiusLg),
        border: Border.all(color: _accent.withValues(alpha: 0.15)),
      ),
      child: Column(children: [
        Row(children: [
          _WeatherIcon(block, size: WSizes.iconXl, fallback: Colors.orangeAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(block.time('EEE, h:mm a'), style: _style(context, 12, sub: true)),
              if (text.isNotEmpty)
                Text(
                  text[0].toUpperCase() + text.substring(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _style(context, 14),
                ),
            ]),
          ),
          Text('${block.temp.round()}°C', style: _style(context, 26, color: _accent)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _Stat(Icons.thermostat, 'Feels', value(main?['feels_like'], '°')),
          _Stat(Icons.water_drop_outlined, 'Humidity', value(main?['humidity'], '%')),
          _Stat(Icons.air, 'Wind', wind == null ? '--' : '$wind m/s'),
          _Stat(Icons.umbrella_outlined, 'Rain', '$rain%'),
        ]),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Icon(icon, size: WSizes.iconSm, color: _accent),
        FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: _style(context, 12))),
        Text(label, style: _style(context, 10, sub: true)),
      ]),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon(this.block, {required this.size, required this.fallback});

  final Map block;
  final double size;
  final Color fallback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Get.find<HomeLogic>().getWeatherIcon(block.icon),
      height: size,
      width: size,
      errorBuilder: (_, __, ___) => Icon(Icons.wb_sunny_rounded, size: size - 4, color: fallback),
    );
  }
}