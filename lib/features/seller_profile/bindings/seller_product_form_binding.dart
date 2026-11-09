import 'package:get/get.dart';

import '../controllers/seller_product_form_controller.dart';
import '../seller_repository.dart';

class SellerProductFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerRepository>(() => SellerRepository(), fenix: true);
    Get.lazyPut<SellerProductFormController>(() => SellerProductFormController(), fenix: true);
  }
}
