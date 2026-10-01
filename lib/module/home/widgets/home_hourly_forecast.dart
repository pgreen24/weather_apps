import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_apps/module/home/home_logic.dart';

class HomeHourlyForecast extends GetView<HomeLogic> {
  const HomeHourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = controller.city.value;
      if (controller.hourlyForecastList.isEmpty) {
        return const SizedBox.shrink();
      }

      final int limit = controller.hourlyForecastList.length > 8 ? 8 : controller.hourlyForecastList.length;
      final List<dynamic> limitedForecast = controller.hourlyForecastList.sublist(0, limit);

      List<FlSpot> spots = [];
      double minTempY = 100.0;
      double maxTempY = -100.0;

      for (int i = 0; i < limitedForecast.length; i++) {
        final double currentTemp = (limitedForecast[i]['main']?['temp'] as num?)?.toDouble() ?? 0.0;
        spots.add(FlSpot(i.toDouble(), currentTemp));

        if (currentTemp < minTempY) minTempY = currentTemp;
        if (currentTemp > maxTempY) maxTempY = currentTemp;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Hourly Forecast",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24.0, right: 16.0),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (limit - 1).toDouble(),
                  minY: minTempY - 2,
                  maxY: maxTempY + 2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: Colors.blueAccent,
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blueAccent,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.25),
                            Colors.blueAccent.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: limit,
              itemBuilder: (context, index) {
                final hourData = limitedForecast[index];

                String timeText = '';
                final String? dtTxt = hourData['dt_txt'];
                if (dtTxt != null) {
                  try {
                    final DateTime parsedTime = DateTime.parse(dtTxt);
                    timeText = DateFormat('hh:mm a').format(parsedTime);
                  } catch (e) {
                    timeText = dtTxt.length >= 16 ? dtTxt.substring(11, 16) : '';
                  }
                }

                String tempText = "${hourData['main']?['temp']?.round() ?? 0}°C";
                final List<dynamic>? weatherList = hourData['weather'] as List<dynamic>?;
                String iconCode = '';
                if (weatherList != null && weatherList.isNotEmpty) {
                  iconCode = weatherList[0]['icon'] ?? '';
                }

                String localIconPath = controller.getWeatherIcon(iconCode);

                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeText,
                        style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        localIconPath,
                        height: 30,
                        width: 30,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_sunny_rounded, color: Colors.orangeAccent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tempText,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
