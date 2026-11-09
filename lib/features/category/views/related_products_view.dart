import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/cart_icon_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/product_grid.dart';
import '../controllers/category_products_controller.dart';

class RelatedProductsView extends StatelessWidget {
  const RelatedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final catname = Get.parameters['catname'] ?? '';
    final controller = Get.find<CategoryProductsController>(tag: 'related_$catname');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Related Products'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RoutesPath.search),
            icon: const Icon(Icons.search, color: AppColors.textMuted),
          ),
          const CartIconButton(),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final category = controller.category.value;

        return RefreshIndicator(
          onRefresh: controller.fetch,
          child: ListView(
            children: [
              if (category != null && category.coverUrl.isNotEmpty)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: AppNetworkImage(
                    url: category.coverUrl,
                    errorBuilder: (_) => Container(color: AppColors.surfaceMuted),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(category?.catname ?? '', style: AppTextStyles.heading),
              ),
              ProductGrid(products: controller.products),
            ],
          ),
        );
      }),
    );
  }
}
