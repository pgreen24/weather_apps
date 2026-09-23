import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:weather_apps/module/splash/splash_screen/splash_mobile.dart';
import 'package:weather_apps/module/splash/splash_screen/splash_tablet.dart';

import '../../utils/keyboard.dart';
import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashLogic>();
    return GestureDetector(
      onTap:() => Keyboard.close(context: context),
      child: ResponsiveBuilder(builder: (BuildContext context,SizingInformation sizingInformation) => ScreenTypeLayout.builder(
        mobile: (BuildContext context) =>
          OrientationLayoutBuilder(portrait:(BuildContext context) => SplashMobileScreen(),landscape: (BuildContext context) => SplashMobileScreen()),
         tablet: (BuildContext context)=>
         OrientationLayoutBuilder(portrait: (BuildContext context) => SplashTabletScreen(),landscape: (BuildContext context) => SplashTabletScreen()),
      ),
      ),
    );
  }
}
