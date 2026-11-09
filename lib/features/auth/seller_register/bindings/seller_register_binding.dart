import 'package:get/get.dart';

import '../controllers/seller_register_controller.dart';

class SellerRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerRegisterController>(() => SellerRegisterController(), fenix: true);
  }
}
