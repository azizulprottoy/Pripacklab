import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/cart_icon_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../comments/views/comments_section.dart';
import '../../reviews/views/reviews_section.dart';
import '../controllers/product_details_controller.dart';
import '../widgets/steps_widget.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? '';
    final controller = Get.find<ProductDetailsController>(tag: 'product_$id');

    return Scaffold(
      appBar: AppBar(title: const Text('Product'), actions: const [CartIconButton()]),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final product = controller.product.value;
        if (product == null) return const SizedBox.shrink();

        return ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Obx(() {
                final img = controller.selectedImage.value ?? product.firstImageUrl;
                return img.isEmpty
                    ? Container(color: AppColors.surfaceMuted)
                    : CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.contain,
                        errorWidget: (_, _, _) => Container(color: AppColors.surfaceMuted),
                      );
              }),
            ),
            if (product.mainPics.length > 1)
              SizedBox(
                height: 64,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: product.imageUrls.length,
                  itemBuilder: (context, index) {
                    final url = product.imageUrls[index];
                    return GestureDetector(
                      onTap: () => controller.selectImage(url),
                      child: Container(
                        width: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName, style: AppTextStyles.heading),
                  const SizedBox(height: 8),
                  Obx(() {
                    final variant = controller.selectedVariant.value;
                    return Row(
                      children: [
                        const Text('Price: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          variant != null ? '${variant.price} ৳' : 'Select options',
                          style: AppTextStyles.price.copyWith(fontSize: 18),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 14),
                  ...product.criteria.map((criterion) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select ${criterion.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: criterion.values.map((value) {
                                final available = controller.isValueAvailable(criterion.name, value);
                                final isSelected = controller.selectedCriteria[criterion.name] == value;
                                return GestureDetector(
                                  onTap: available ? () => controller.selectCriteria(criterion.name, value) : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: !available
                                            ? AppColors.border
                                            : (isSelected ? Colors.transparent : AppColors.primary),
                                      ),
                                    ),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: !available
                                            ? AppColors.textFaint
                                            : (isSelected ? Colors.white : AppColors.primary),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    final variant = controller.selectedVariant.value;
                    final discount = double.tryParse(variant?.discount ?? '') ?? 0;
                    if (variant == null || discount <= 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Discount: ${variant.discount}%',
                        style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                      ),
                    );
                  }),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.addToCart,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('Add to Cart', style: TextStyle(color: AppColors.primary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.buyNow,
                          child: const Text('Buy Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() => StepsWidget(
                  step1: controller.step1.value,
                  step2: controller.step2.value,
                  step3: controller.step3.value,
                )),
            if (product.productDescription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Html(data: product.productDescription),
              ),
            ReviewsSection(productId: id),
            CommentsSection(productId: id),
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }
}
