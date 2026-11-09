import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/routes_path.dart';
import '../../features/cart/controllers/cart_controller.dart';
import '../../res/theme/app_colors.dart';

/// Persistent cart shortcut with a live item-count badge, ported from
/// reacttemplate's Header2.jsx `<Cart />` — shown in every browse screen's
/// app bar, not just Home.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () => Get.toNamed(RoutesPath.cart),
          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted),
        ),
        Obx(
          () => cart.count == 0
              ? const SizedBox.shrink()
              : Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${cart.count}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
