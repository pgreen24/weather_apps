import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/asset_constant.dart';


class SplashMobileScreen extends StatelessWidget {
  const SplashMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(padding: const EdgeInsets.only(left: 10), child: Lottie.asset(AssetConstants.splashAnimation)),
            ),
            const Center(
              child: Padding(padding: EdgeInsets.only(bottom: 30), child: CupertinoActivityIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
