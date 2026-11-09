import 'package:get/get.dart';

import '../../../shared/repositories/geo_repository.dart';
import '../controllers/seller_dashboard_controller.dart';
import '../controllers/seller_orders_controller.dart';
import '../controllers/seller_products_controller.dart';
import '../seller_repository.dart';

class SellerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerRepository>(() => SellerRepository(), fenix: true);
    Get.lazyPut<GeoRepository>(() => GeoRepository(), fenix: true);
    Get.lazyPut<SellerDashboardController>(() => SellerDashboardController(), fenix: true);
    Get.lazyPut<SellerProductsController>(() => SellerProductsController(), fenix: true);
    Get.lazyPut<SellerOrdersController>(() => SellerOrdersController(), fenix: true);
  }
}
