import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_apps/module/home/home_logic.dart';
import 'package:weather_apps/module/home/widgets/home_main_image_view.dart';

import '../../../utils/app_size.dart';
import '../../../utils/asset_constant.dart';

class HomeLocationAndTempView extends GetView<HomeLogic>{
  const HomeLocationAndTempView ({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Column(
        spacing:WSizes.defaultSpacing,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: WSizes.iconSm -5,
            children: [
              Text(controller.city.value,
              style:Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontSize: 42,
                letterSpacing: 0.95,
                fontWeight: FontWeight.w900,
              ),
              ),
              const HomeMainImageView(imagePath: AssetConstants.locationIcon,
              imageWidth:20,
              imageHeight: 20,
              )
            ],
          ),
          Obx(() {
            final textStyle = Theme.of(context).textTheme.headlineLarge!;
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  controller.temp.value,
                  style: textStyle.copyWith(fontSize: 60, fontWeight: FontWeight.w900, letterSpacing: 0.95),
                ),
                Baseline(
                  baseline: 32,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    '°C',
                    style: textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),

          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                controller.weatherMain.value,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),


              Text(
                "${controller.tempmin.value}°C ~  ${controller.tempmax.value}°C  Feels like: ${controller.feelslike.value}°C",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ))


        ]

      );
    });
  }
}