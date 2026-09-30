import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_size.dart';
import '../home_logic.dart';

class HomeDistrict extends GetView<HomeLogic> {

  HomeDistrict({super.key});

  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  void _scrollToSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[index];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.district.indexOf(controller.selectedDistrict.value);

      if (selectedIndex != -1) {
        _scrollToSelected(selectedIndex);
      }

      return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          spacing: WSizes.spaceBtwItems,
          children: List.generate(controller.district.length, (index) {
            final city = controller.district[index];
            final isSelected = controller.selectedDistrict.value == city;

            _itemKeys[index] ??= GlobalKey();

            return ActionChip(
              key: _itemKeys[index],
              label: Text(
                city,

                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (Get.isDarkMode ? Colors.white : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : (Get.isDarkMode ? Colors.grey.shade800 : const Color(0xFFF7F7F9)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WSizes.borderRadiusLg),
                side: BorderSide.none,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              onPressed: () {

                controller.allDistrictsFromApi(city);
              },
            );
          }),
        ),
      );
    });
  }
}
