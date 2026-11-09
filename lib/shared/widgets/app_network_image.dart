import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Category endpoints (`iconpic`/`pagecover`) serve `.svg` files, which
/// `cached_network_image`'s raster decoder cannot handle — Android's
/// ImageDecoder throws `unimplemented`, and repeated failures were
/// destabilizing the emulator's renderer. Route `.svg` URLs through
/// `flutter_svg` instead; everything else keeps using CachedNetworkImage.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext context)? errorBuilder;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  bool get _isSvg => url.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: errorBuilder,
        errorBuilder: errorBuilder != null ? (context, _, _) => errorBuilder!(context) : null,
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorBuilder != null ? (context, _, _) => errorBuilder!(context) : null,
    );
  }
}
