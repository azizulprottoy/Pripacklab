import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/rating_stars.dart';
import '../controllers/reviews_controller.dart';

class ReviewsSection extends StatelessWidget {
  final String productId;

  const ReviewsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewsController>(tag: 'product_$productId');

    return Obx(() {
      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer Reviews', style: AppTextStyles.subheading),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        controller.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                      RatingStars(rating: controller.averageRating),
                      Text('${controller.totalReviews} reviews', style: AppTextStyles.bodyMuted),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [5, 4, 3, 2, 1].map((star) {
                        final count = controller.starCounts[star] ?? 0;
                        final pct = controller.totalReviews == 0 ? 0.0 : count / controller.totalReviews;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              SizedBox(width: 28, child: Text('$star ★', style: AppTextStyles.bodyMuted)),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 6,
                                    backgroundColor: AppColors.border,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(width: 20, child: Text('$count', style: AppTextStyles.bodyMuted)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...controller.reviews.map((review) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.customerName.isEmpty ? 'Customer' : review.customerName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          if (review.createdAt != null)
                            Text(
                              DateFormat.yMMMd().format(review.createdAt!),
                              style: AppTextStyles.bodyMuted.copyWith(fontSize: 11),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RatingStars(rating: review.rating.toDouble(), size: 12),
                      const SizedBox(height: 6),
                      Text(review.message, style: AppTextStyles.body),
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }
}
