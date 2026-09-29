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

    final RxList<dynamic> filteredDistricts = <dynamic>[].obs;
    final RxBool isSearching = false.obs;

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
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: TextField(
                        style: TextStyle(color: textColor),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            isSearching.value = false;
                            filteredDistricts.clear();
                          } else {
                            isSearching.value = true;
                            filteredDistricts.assignAll(
                              controller.district.where((element) =>
                                  element.toString().toLowerCase().contains(value.toLowerCase())),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter District name',
                          hintStyle: TextStyle(color: textColor.withValues(alpha: 0.6)),
                          border: InputBorder.none,
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

                  if (!isSearching.value) {
                    return const SizedBox.shrink();
                  }

                  if (filteredDistricts.isEmpty) {
                    return Center(
                      child: Text(
                        'No district found',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredDistricts.length,
                    itemBuilder: (context, index) {
                      final districtName = filteredDistricts[index].toString();
                      return ListTile(
                        title: Text(
                          districtName,
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        onTap: () async {
                          controller.cityName.value = districtName;
                          await controller.weatherData();
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


