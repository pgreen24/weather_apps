import 'package:get/get.dart';
import 'data_model/weather_data_model.dart';

class HomeLogic extends GetxController {
  RxBool isLoading = true.obs;
  var weatherList = <WeatherDataModel>[].obs;
  var homeCity = ''.obs, homeTemp = ''.obs, homeIcon = ''.obs;
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
    });
  }


}
