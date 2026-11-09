import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/routes_path.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/cart/controllers/cart_controller.dart';
import '../repositories/category_repository.dart';
import '../models/category_model.dart';
import '../../res/theme/app_colors.dart';
import '../../res/theme/app_text_styles.dart';
import 'app_network_image.dart';

enum MainNavTab { home, cart, categories, profile }

/// Ports reacttemplate's mobile Footer nav (Home/Cart/Categories/Profile).
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
        onTap: (index) => _onTap(context, MainNavTab.values[index], auth),
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
          const BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Categories'),
          BottomNavigationBarItem(
            icon: Icon(auth.isLoggedIn ? Icons.person_outline : Icons.login),
            label: auth.isLoggedIn ? 'Profile' : 'Login',
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, MainNavTab tab, AuthController auth) {
    switch (tab) {
      case MainNavTab.home:
        if (current != tab) Get.offAllNamed(RoutesPath.shell);
      case MainNavTab.cart:
        if (current != tab) Get.toNamed(RoutesPath.cart);
      case MainNavTab.categories:
        _showCategoriesSheet(context);
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

  void _showCategoriesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _CategoriesSheet(),
    );
  }
}

class _CategoriesSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: Get.find<CategoryRepository>().getCategories(),
      builder: (context, snapshot) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('Categories', style: AppTextStyles.subheading),
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())
                else if (!snapshot.hasData || snapshot.data!.isEmpty)
                  const Padding(padding: EdgeInsets.all(24), child: Text('No categories found.', style: AppTextStyles.bodyMuted))
                else
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 3.2,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final cat = snapshot.data![index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Get.back();
                            Get.toNamed('${RoutesPath.categoryDetails}/${cat.id}');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: cat.iconUrl.isEmpty
                                      ? Container(width: 32, height: 32, color: AppColors.surfaceMuted)
                                      : AppNetworkImage(
                                          url: cat.iconUrl,
                                          width: 32,
                                          height: 32,
                                          errorBuilder: (_) => Container(width: 32, height: 32, color: AppColors.surfaceMuted),
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(cat.catname, style: AppTextStyles.body, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
