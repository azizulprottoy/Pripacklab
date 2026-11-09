import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Touch `controller` so GetX actually instantiates SplashController
    // (lazyPut is lazy — if a view never reads `controller`, Get.find()
    // never runs and onInit/onReady are never called).
    controller;

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PripackLab',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
