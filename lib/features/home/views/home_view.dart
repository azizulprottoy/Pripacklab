import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../res/theme/app_colors.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import '../controllers/home_controller.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/home_product_row.dart';
import '../widgets/popup_ad_dialog.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ever(controller.ads, (_) {
      final ad = controller.popupAd;
      if (ad != null && !controller.popupDismissed.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showPopupAd(context, ad, controller.dismissPopup);
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('PripackLab', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RoutesPath.search),
            icon: const Icon(Icons.search, color: AppColors.textMuted),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();

        return RefreshIndicator(
          onRefresh: controller.fetchHome,
          child: ListView(
            children: [
              BannerCarousel(banners: controller.banners),
              const SizedBox(height: 14),
              CategoryGrid(categories: controller.cats),
              ...controller.categories.map((section) => HomeProductRow(section: section)),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
      bottomNavigationBar: const MainBottomNav(current: MainNavTab.home),
    );
  }
}
