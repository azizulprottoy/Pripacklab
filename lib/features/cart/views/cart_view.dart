import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../core/utils/image_url.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import '../controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Obx(() {
        if (cart.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.textFaint),
                SizedBox(height: 12),
                Text('Your cart is empty', style: AppTextStyles.bodyMuted),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: cart.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = cart.items[index];
            final image = resolveImageUrl(item.selectedImage ?? (item.mainPics.isNotEmpty ? item.mainPics.first : null));

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.isEmpty
                        ? Container(width: 64, height: 64, color: AppColors.border)
                        : CachedNetworkImage(imageUrl: image, width: 64, height: 64, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.productName, style: AppTextStyles.subheading, maxLines: 1, overflow: TextOverflow.ellipsis),
                        if (item.combination.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Wrap(
                            spacing: 8,
                            children: item.combination.entries
                                .map((e) => Text('${e.key}: ${e.value}', style: AppTextStyles.bodyMuted))
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _qtyButton(Icons.remove, () => cart.updateUnits(index, -1)),
                                SizedBox(
                                  width: 28,
                                  child: Text('${item.units}', textAlign: TextAlign.center, style: AppTextStyles.body),
                                ),
                                _qtyButton(Icons.add, () => cart.updateUnits(index, 1)),
                              ],
                            ),
                            Text('৳${item.lineTotal.toStringAsFixed(2)}', style: AppTextStyles.price),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: AppColors.textFaint),
                    onPressed: () => cart.removeAt(index),
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (cart.items.isEmpty) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: AppTextStyles.bodyMuted),
                        Text('৳${cart.totalPrice.toStringAsFixed(2)}', style: AppTextStyles.heading),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(RoutesPath.checkout),
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const MainBottomNav(current: MainNavTab.cart),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.border), color: Colors.white),
        child: Icon(icon, size: 12, color: AppColors.textMuted),
      ),
    );
  }
}
