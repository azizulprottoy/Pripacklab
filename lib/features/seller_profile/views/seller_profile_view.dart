import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import '../controllers/seller_dashboard_controller.dart';
import 'seller_orders_view.dart';
import 'seller_products_view.dart';

class SellerProfileView extends GetView<SellerDashboardController> {
  const SellerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seller Dashboard'),
          actions: [
            IconButton(
              onPressed: controller.auth.logout,
              icon: const Icon(Icons.logout, color: AppColors.textMuted),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Orders'),
            ],
          ),
        ),
        body: Column(
          children: [
            _sellerCard(),
            const Expanded(
              child: TabBarView(
                children: [
                  SellerProductsView(),
                  SellerOrdersView(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MainBottomNav(current: MainNavTab.profile),
      ),
    );
  }

  Widget _sellerCard() {
    return Obx(() {
      final user = controller.auth.user.value;
      if (user == null) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.emerald,
              child: Text(
                user.name.isEmpty ? 'S' : user.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppTextStyles.subheading),
                  Text(user.email, style: AppTextStyles.bodyMuted),
                  Text(user.phone, style: AppTextStyles.bodyMuted),
                  Text(
                    [controller.divisionName.value, controller.districtName.value, controller.subDistrictName.value]
                        .where((e) => e.isNotEmpty)
                        .join(', '),
                    style: AppTextStyles.bodyMuted,
                  ),
                  if (user.services.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: user.services
                            .map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(s, style: const TextStyle(fontSize: 11, color: AppColors.primaryDark)),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
