import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/models/ad_model.dart';

void showPopupAd(BuildContext context, AdModel ad, VoidCallback onClose) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onTap: () {
                  final link = ad.rdlink.startsWith('http') ? ad.rdlink : 'https://${ad.rdlink}';
                  if (ad.rdlink.isNotEmpty) launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                },
                child: CachedNetworkImage(imageUrl: ad.imglink, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: -12,
              right: -12,
              child: GestureDetector(
                onTap: () {
                  onClose();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
