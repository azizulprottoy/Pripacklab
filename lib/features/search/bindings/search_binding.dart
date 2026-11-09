import 'package:get/get.dart';

import '../../../shared/repositories/product_repository.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => ProductRepository(), fenix: true);
    Get.lazyPut<ProductSearchController>(() => ProductSearchController(), fenix: true);
  }
}
