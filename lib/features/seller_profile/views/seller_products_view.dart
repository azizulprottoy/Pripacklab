import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../controllers/seller_products_controller.dart';

class SellerProductsView extends GetView<SellerProductsController> {
  const SellerProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();

        if (controller.products.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchProducts,
            child: ListView(
              children: const [
                SizedBox(height: 80),
                Icon(Icons.inventory_2_outlined, size: 56, color: AppColors.textFaint),
                SizedBox(height: 12),
                Center(child: Text('No products found.', style: AppTextStyles.bodyMuted)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          child: ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: controller.products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.firstImageUrl.isEmpty
                          ? Container(width: 56, height: 56, color: AppColors.surfaceMuted)
                          : CachedNetworkImage(imageUrl: product.firstImageUrl, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.productName, style: AppTextStyles.subheading),
                          Text('${product.category} · ${product.subCategory ?? '-'}', style: AppTextStyles.bodyMuted),
                          Text('${product.variants.length} variant(s)', style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textMuted),
                      onPressed: () async {
                        final result = await Get.toNamed(RoutesPath.sellerProductForm, arguments: product);
                        if (result == true) controller.fetchProducts();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => _confirmDelete(context, product.id),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
      // startFloat (bottom-left) — the global support-chat bubble occupies
      // bottom-right on every screen, so this would otherwise sit under it.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.toNamed(RoutesPath.sellerProductForm);
          if (result == true) controller.fetchProducts();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: const Text('This product will be permanently deleted.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(id);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
