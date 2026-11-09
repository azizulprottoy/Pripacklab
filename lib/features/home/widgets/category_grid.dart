import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/widgets/app_network_image.dart';

const int _collapsedCount = 12;

class CategoryGrid extends StatefulWidget {
  final List<CategoryModel> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;
    if (categories.isEmpty) return const SizedBox.shrink();

    final hasMore = categories.length > _collapsedCount;
    final shown = _expanded ? categories : categories.take(_collapsedCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shop by Category', style: AppTextStyles.subheading),
              if (hasMore)
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? 'Show less' : 'Show all (${categories.length})'),
                ),
            ],
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shown.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final cat = shown[index];
            return GestureDetector(
              onTap: () => Get.toNamed('${RoutesPath.categoryDetails}/${cat.id}'),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: cat.iconUrl.isEmpty
                          ? Container(color: AppColors.surfaceMuted, child: const Icon(Icons.category_outlined, color: AppColors.textFaint))
                          : AppNetworkImage(
                              url: cat.iconUrl,
                              errorBuilder: (_) => Container(
                                color: AppColors.surfaceMuted,
                                child: const Icon(Icons.category_outlined, color: AppColors.textFaint),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.catname,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMuted.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
