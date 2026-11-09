import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../app/routes/routes_path.dart';
import '../../res/theme/app_colors.dart';
import '../../res/theme/app_text_styles.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? width;

  const ProductCard({super.key, required this.product, this.width = 170});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('${RoutesPath.productDetails}/${product.id}'),
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: product.firstImageUrl.isEmpty
                  ? Container(color: AppColors.surfaceMuted)
                  : CachedNetworkImage(
                      imageUrl: product.firstImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(color: AppColors.surfaceMuted),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.surfaceMuted,
                        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textFaint),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.avgRating,
                        itemCount: 5,
                        itemSize: 12,
                        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      ),
                      const SizedBox(width: 4),
                      Text('(${product.totalRatings})', style: AppTextStyles.bodyMuted.copyWith(fontSize: 10)),
                    ],
                  ),
                  if (product.priceRange != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.priceRange!.min == product.priceRange!.max
                          ? '৳${product.priceRange!.min.toStringAsFixed(0)}'
                          : '৳${product.priceRange!.min.toStringAsFixed(0)} - ${product.priceRange!.max.toStringAsFixed(0)}',
                      style: AppTextStyles.price.copyWith(fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
