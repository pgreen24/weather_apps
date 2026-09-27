import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_size.dart';
import '../../../utils/apps_color.dart';
import '../home_logic.dart';

class HomeQuickStateView extends GetView<HomeLogic> {
  const HomeQuickStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: WSizes.defaultSpacing,
          horizontal: WSizes.defaultSpacing - 6
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppsColor.darkerGrey.withValues(alpha: 0.5) : AppsColor.white,
        borderRadius: BorderRadius.circular(WSizes.borderRadiusMd),
        border: Border.all(color: AppsColor.darkGrey.withValues(alpha: 0.5), width: 0.5),
      ),

      child: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (controller.weatherList.isEmpty) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(context: context, title: 'TIME', value: '--:--'),
              _buildStatColumn(context: context, title: 'WIND', value: '--'),
              _buildStatColumn(context: context, title: '% RAIN', value: '--%'),
              _buildStatColumn(context: context, title: 'HUMIDITY', value: '--'),
            ],
          );
        }
        final weather = controller.weatherList.first;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _buildStatColumn(
                context: context,
                title: 'TIME',
                value: weather.formattedLocalTime
            ),

            _buildStatColumn(
                context: context,
                title: 'WIND',
                value: '${weather.windSpeed.toStringAsFixed(1)} m/s'
            ),

            _buildStatColumn(
                context: context,
                title: '% RAIN',
                value: '${weather.clouds}%'
            ),

            _buildStatColumn(
                context: context,
                title: 'HUMIDITY',
                value: '${weather.humidity}%'
            ),
          ],
        );
      }),
    );
  }

  static Widget _buildStatColumn({required BuildContext context, required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
