import 'package:get/get.dart';

import 'shimmer_logic.dart';

class ShimmerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShimmerLogic());
  }
}
