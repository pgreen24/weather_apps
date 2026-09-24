import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:weather_apps/module/home/home_screen/home_mobile.dart';
import 'package:weather_apps/module/home/home_screen/home_tablet.dart';

import '../../utils/keyboard.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<HomeLogic>();
    return GestureDetector(
      onTap:() => Keyboard.close(context: context),
      child: ResponsiveBuilder(
          builder: (BuildContext context, SizingInformation sizingInformation) => ScreenTypeLayout.builder(
            mobile: (BuildContext context) =>
                 OrientationLayoutBuilder(portrait: (BuildContext context)=> HomeMobile(), landscape: (BuildContext context) => HomeMobile()),
            tablet: (BuildContext context) =>
            OrientationLayoutBuilder(portrait: (BuildContext context) => HomeTablet(),landscape: (BuildContext context) => HomeTablet()),
          ),
          ),
    );
  }
}
