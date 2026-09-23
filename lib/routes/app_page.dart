import 'package:get/get.dart';
import '../module/home/home_binding.dart';
import '../module/home/home_view.dart';
import '../module/shimmer/shimmer_binding.dart';
import '../module/shimmer/shimmer_view.dart';
import '../module/splash/splash_binding.dart';
import '../module/splash/splash_view.dart';
import 'app_routes.dart';

class AppPage {
  static final initial = AppRoutes.splash;
  static  final routes =[
    GetPage(name: AppRoutes.splash, page: () => SplashPage(),bindings:[SplashBinding()]),
    GetPage(name: AppRoutes.shimmer, page: () => ShimmerPage(),bindings:[ShimmerBinding()]),
    GetPage(name: AppRoutes.home, page: () => HomePage(),bindings:[HomeBinding()]),

  ];
}