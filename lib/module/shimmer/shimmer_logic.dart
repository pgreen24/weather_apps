import 'package:get/get.dart';

class ShimmerLogic extends GetxController {
  var isLoading =true.obs;
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
