import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/routes_path.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/cart/controllers/cart_controller.dart';
import '../../res/theme/app_colors.dart';

enum MainNavTab { home, cart, about, profile }

/// Ports reacttemplate's mobile Footer nav (Home/Cart/About/Profile).
/// Rendered per-screen (Home/Cart/Profile) rather than as a shared
/// IndexedStack shell, since each destination is an existing GetX-bound
/// route — that avoids re-plumbing bindings for a nested-tab navigator.
class MainBottomNav extends StatelessWidget {
  final MainNavTab current;

  const MainBottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final cart = Get.find<CartController>();

    return Obx(
      () => BottomNavigationBar(
        currentIndex: current.index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textFaint,
        onTap: (index) => _onTap(MainNavTab.values[index], auth),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (cart.count > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                      child: Text(
                        '${cart.count}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(auth.isLoggedIn ? Icons.person_outline : Icons.login),
            label: auth.isLoggedIn ? 'Profile' : 'Login',
          ),
        ],
      ),
    );
  }

  void _onTap(MainNavTab tab, AuthController auth) {
    switch (tab) {
      case MainNavTab.home:
        if (current != tab) Get.offAllNamed(RoutesPath.shell);
      case MainNavTab.cart:
        if (current != tab) Get.toNamed(RoutesPath.cart);
      case MainNavTab.about:
        Get.toNamed(RoutesPath.about);
      case MainNavTab.profile:
        if (current != tab) {
          if (!auth.isLoggedIn) {
            Get.toNamed(RoutesPath.login);
          } else {
            Get.toNamed(RoutesPath.profile);
          }
        }
    }
  }
}
