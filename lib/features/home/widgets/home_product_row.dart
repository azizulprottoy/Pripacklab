import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/product_card.dart';
import '../models/home_data.dart';

class HomeProductRow extends StatelessWidget {
  final HomeCategorySection section;

  const HomeProductRow({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(section.catname, style: AppTextStyles.subheading),
                GestureDetector(
                  onTap: () => Get.toNamed('${RoutesPath.categoryDetails}/${section.id}'),
                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: section.products.length,
              itemBuilder: (context, index) => ProductCard(product: section.products[index]),
            ),
          ),
        ],
      ),
    );
  }
}
