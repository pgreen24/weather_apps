import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_size.dart';
import '../home_logic.dart';
class HomeDistrict  extends GetView<HomeLogic> {
  const HomeDistrict({super.key,});

  @override
  Widget build(BuildContext context) {
return Obx(() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: WSizes.spaceBtwItems,
        children: List.generate(controller.district .length, (index) {
          final city = controller.district [index];

          return ActionChip(
            label: Text(
              city,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : const Color(0xFFF7F7F9),
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
