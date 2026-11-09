import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/theme/app_colors.dart';
import '../../../shared/widgets/cart_icon_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/product_grid.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<ProductSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: controller.setQuery,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
        actions: const [CartIconButton()],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();

        if (controller.query.value.trim().isEmpty) {
          return const Center(
            child: Text('Start typing to search products', style: TextStyle(color: AppColors.textFaint)),
          );
        }

        final results = controller.filtered;
        if (results.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        return ProductGrid(products: results);
      }),
    );
  }
}
