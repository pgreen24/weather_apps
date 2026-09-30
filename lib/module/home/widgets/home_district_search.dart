import 'package:get/get.dart';
import 'package:weather_apps/module/home/home_logic.dart';
import 'package:flutter/material.dart';
import '../../../utils/apps_color.dart';

class HomeDistrictSearch extends GetView<HomeLogic> {
  const HomeDistrictSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Get.isDarkMode
        ? AppsColor.darkerGrey.withValues(alpha: 0.5)
        : AppsColor.white;

    final textColor = Get.isDarkMode ? AppsColor.white : const Color(0xFF1E2432);

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () {
                        controller.searchDistricts.clear();
                        controller.isSearching.value = false;
                        Get.back();
                      }
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        style: TextStyle(color: textColor),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            controller.isSearching.value = false;
                            controller.searchDistricts.clear();
                          } else {
                            controller.isSearching.value = true;
                            controller.searchDistricts.assignAll(
                              controller.district.where((element) =>
                                  element.toString().toLowerCase().contains(value.toLowerCase())),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter District name',
                          hintStyle: TextStyle(color: textColor.withValues(alpha: 0.6)),
                          suffixIcon: Icon(Icons.search, color: textColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),


              Expanded(
                child: Obx(() {

                  if (!controller.isSearching.value) {
                    if (controller.searchHistory.isEmpty) {
                      return Center(
                        child: Text(
                          "No search history",
                          style: TextStyle(color: textColor.withValues(alpha: 0.5)),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.searchHistory.length,
                      itemBuilder: (context, index) {
                        final historyCity = controller.searchHistory[index];
                        return ListTile(
                          leading: Icon(Icons.history, color: textColor.withValues(alpha: 0.6)),
                          title: Text(
                            historyCity,
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.clear, size: 20, color: Colors.redAccent),
                            onPressed: () {
                              controller.removeFromHistory(historyCity);
                            },
                          ),
                          onTap: () async {
                            controller.cityName.value = historyCity;
                            controller.selectedDistrict.value = historyCity;
                            await controller.weatherData();
                            Get.back();
                          },
                        );
                      },
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.searchDistricts.length,
                    itemBuilder: (context, index) {
                      final districtName = controller.searchDistricts[index].toString();
                      return ListTile(
                        title: Text(
                          districtName,
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        onTap: () async {
                          controller.addToHistory(districtName);
                          controller.cityName.value = districtName;
                          controller.selectedDistrict.value = districtName;
                          await controller.weatherData();
                          controller.searchDistricts.clear();
                          controller.isSearching.value = false;
                          Get.back();
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
