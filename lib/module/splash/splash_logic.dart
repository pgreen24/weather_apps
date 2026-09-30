import 'package:get/get.dart';
import 'package:weather_apps/routes/app_routes.dart';

class SplashLogic extends GetxController {
  @override
  Future<void>onInit () async{
    super.onInit();

    await Future.delayed(Duration(seconds: 5), (){
      Get.offAllNamed(AppRoutes.home);
    });
  }

}
