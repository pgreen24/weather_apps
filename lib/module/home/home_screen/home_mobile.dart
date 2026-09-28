import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_apps/module/home/home_logic.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style/style_padding.dart';
import '../../shimmer/shimmer_view.dart';
import '../widgets/home_district.dart';
import '../widgets/home_location_and_temp_view.dart';
import '../widgets/home_main_image_view.dart';
import '../widgets/home_quick_state_view.dart';
import '../widgets/home_sunrise_and_temp_view.dart';
class HomeMobile extends GetView<HomeLogic> {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return ShimmerPage();
        }
        return SafeArea(
          child: Padding(
            padding: StylePadding.screenPaddingMobile,
            child: Column(
              spacing: WSizes.defaultSpacing,
              children: <Widget>[
                const HomeDistrict(),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: WSizes.defaultSpacing,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HomeMainImageView(imagePath:controller.homeIcon.value, imageHeight: 200),
                        const HomeLocationAndTempView(),
                        const HomeQuickStateView(),
                        const HomeSunriseAndSunsetView(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}