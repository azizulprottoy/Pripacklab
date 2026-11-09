import 'package:get/get.dart';

import '../../checkout_repository.dart';
import '../controllers/payment_gateway_controller.dart';

class PaymentGatewayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutRepository>(() => CheckoutRepository(), fenix: true);
    Get.lazyPut<PaymentGatewayController>(() => PaymentGatewayController(), fenix: true);
  }
}
