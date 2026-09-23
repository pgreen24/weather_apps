import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:weather_apps/routes/app_page.dart';
import 'package:weather_apps/utils/theme/theme.dart';
void main()  {

  WidgetsFlutterBinding.ensureInitialized();

  ResponsiveSizingConfig.instance.setCustomBreakpoints(const ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200));

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'weather App',
      initialRoute: AppPage.initial,
      getPages: AppPage.routes,
      smartManagement: SmartManagement.keepFactory,
      defaultTransition: Transition.fade,
      themeMode: ThemeMode.system,
      darkTheme: WAppTheme.darkTheme,
      theme: WAppTheme.lightTheme,
    );
  }
}