import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../res/theme/app_colors.dart';
import '../../../shared/models/banner_model.dart';

class BannerCarousel extends StatelessWidget {
  final List<BannerModel> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        viewportFraction: 1,
        autoPlay: banners.length > 1,
        autoPlayInterval: const Duration(seconds: 4),
      ),
      items: banners.map((b) {
        final url = b.phoneUrl.isNotEmpty ? b.phoneUrl : b.webUrl;
        return url.isEmpty
            ? Container(color: AppColors.surfaceMuted)
            : CachedNetworkImage(
                imageUrl: url,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: AppColors.surfaceMuted),
                errorWidget: (_, _, _) => Container(color: AppColors.surfaceMuted),
              );
      }).toList(),
    );
  }
}
