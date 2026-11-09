import 'package:get/get.dart';

import '../checkout_repository.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutRepository>(() => CheckoutRepository(), fenix: true);
    Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
  }
}
