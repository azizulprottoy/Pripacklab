import 'package:get/get.dart';

import '../../orders/orders_repository.dart';
import '../../reviews/review_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersRepository>(() => OrdersRepository(), fenix: true);
    Get.lazyPut<ReviewRepository>(() => ReviewRepository(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
