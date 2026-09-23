import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shimmer_logic.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShimmerLogic logic = Get.put(ShimmerLogic());

    return Container();
  }
}
