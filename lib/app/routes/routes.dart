import 'package:get/get.dart';

import '../../features/auth/login/bindings/login_binding.dart';
import '../../features/auth/login/views/login_view.dart';
import '../../features/auth/seller_register/bindings/seller_register_binding.dart';
import '../../features/auth/seller_register/views/seller_register_view.dart';
import '../../features/auth/signup/bindings/signup_binding.dart';
import '../../features/auth/signup/views/signup_view.dart';
import '../../features/cart/views/cart_view.dart';
import '../../features/category/bindings/category_details_binding.dart';
import '../../features/category/bindings/related_products_binding.dart';
import '../../features/category/views/category_details_view.dart';
import '../../features/category/views/related_products_view.dart';
import '../../features/checkout/bindings/checkout_binding.dart';
import '../../features/checkout/payment/bindings/payment_gateway_binding.dart';
import '../../features/checkout/payment/views/payment_gateway_view.dart';
import '../../features/checkout/views/checkout_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/product_details/bindings/product_details_binding.dart';
import '../../features/product_details/views/product_details_view.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/search/bindings/search_binding.dart';
import '../../features/search/views/search_view.dart';
import '../../features/seller_profile/bindings/seller_product_form_binding.dart';
import '../../features/seller_profile/bindings/seller_profile_binding.dart';
import '../../features/seller_profile/views/seller_product_form_view.dart';
import '../../features/seller_profile/views/seller_profile_view.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/about/views/about_view.dart';
import 'routes_path.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: RoutesPath.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: RoutesPath.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RoutesPath.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: RoutesPath.sellerRegister,
      page: () => const SellerRegisterView(),
      binding: SellerRegisterBinding(),
    ),
    GetPage(
      name: RoutesPath.shell,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RoutesPath.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RoutesPath.categoryDetailsPattern,
      page: () => const CategoryDetailsView(),
      binding: CategoryDetailsBinding(),
    ),
    GetPage(
      name: RoutesPath.relatedProductsPattern,
      page: () => const RelatedProductsView(),
      binding: RelatedProductsBinding(),
    ),
    GetPage(
      name: RoutesPath.productDetailsPattern,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: RoutesPath.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: RoutesPath.cart,
      page: () => const CartView(),
    ),
    GetPage(
      name: RoutesPath.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: RoutesPath.paymentGateway,
      page: () => const PaymentGatewayView(),
      binding: PaymentGatewayBinding(),
    ),
    GetPage(
      name: RoutesPath.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: RoutesPath.sellerProfile,
      page: () => const SellerProfileView(),
      binding: SellerProfileBinding(),
    ),
    GetPage(
      name: RoutesPath.sellerProductForm,
      page: () => const SellerProductFormView(),
      binding: SellerProductFormBinding(),
    ),
    GetPage(
      name: RoutesPath.about,
      page: () => const AboutView(),
    ),
  ];
}
