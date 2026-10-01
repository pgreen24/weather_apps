import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../home_logic.dart';

class HomeDailyForecast extends GetView<HomeLogic> {
  const HomeDailyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isExpanded = false.obs;

    return Obx(() {
      if (controller.hourlyForecastList.isEmpty) {
        return const SizedBox.shrink();
      }

      final Map<String, List<dynamic>> groupedByDay = {};
      for (var block in controller.hourlyForecastList) {
        final String dtTxt = block['dt_txt'] ?? '';
        if (dtTxt.length >= 10) {
          final String dateKey = dtTxt.substring(0, 10);
          if (!groupedByDay.containsKey(dateKey)) {
            groupedByDay[dateKey] = [];
          }
          groupedByDay[dateKey]!.add(block);
        }
      }

      final List<String> sortedDates = groupedByDay.keys.toList()..sort();
      final int itemCount = isExpanded.value ? 7 : 2;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Next 7 Days Forecast",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                GestureDetector(
                  onTap: () {
                    isExpanded.value = !isExpanded.value;
                  },
                  child: Text(
                    isExpanded.value ? "Show Less" : "See All",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
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
                color: Colors.blueAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.1), width: 1),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.blueAccent.withOpacity(0.1),
                  height: 20,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final DateTime now = DateTime.now();
                  final DateTime targetDate = now.add(Duration(days: index));
                  final String dateString = DateFormat('yyyy-MM-dd').format(targetDate);

                  String dayTitle = '';
                  if (index == 0) {
                    dayTitle = "Today";
                  } else if (index == 1) {
                    dayTitle = "Tomorrow";
                  } else {
                    dayTitle = DateFormat('EEEE').format(targetDate);
                  }

                  List<dynamic>? dayBlocks;
                  if (groupedByDay.containsKey(dateString)) {
                    dayBlocks = groupedByDay[dateString];
                  } else {
                    dayBlocks = groupedByDay.isNotEmpty ? groupedByDay[sortedDates.last] : null;
                  }

                  double maxTemp = -999.0;
                  double minTemp = 999.0;

                  if (dayBlocks != null) {
                    for (var block in dayBlocks) {
                      final double tempMax = (block['main']?['temp_max'] as num?)?.toDouble() ?? 0.0;
                      final double tempMin = (block['main']?['temp_min'] as num?)?.toDouble() ?? 0.0;
                      if (tempMax > maxTemp) maxTemp = tempMax;
                      if (tempMin < minTemp) minTemp = tempMin;
                    }
                  }

                  final firstBlock = dayBlocks?.first;
                  final String status = firstBlock != null ? (firstBlock['weather']?[0]?['main'] ?? 'Clear').toString() : 'Clear';
                  final String iconCode = firstBlock != null ? (firstBlock['weather']?[0]?['icon'] ?? '01d').toString() : '01d';
                  final String localIconPath = controller.getWeatherIcon(iconCode);


                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 85,
                          child: Text(
                            dayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              Image.asset(
                                localIconPath,
                                height: 25,
                                width: 25,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.wb_sunny_rounded, color: Colors.orangeAccent, size: 22),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  status,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${maxTemp == -999.0 ? '--' : maxTemp.round()}°",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${minTemp == 999.0 ? '--' : minTemp.round()}°",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
