import 'package:get/get.dart';

import '../../../shared/repositories/category_repository.dart';
import '../controllers/category_products_controller.dart';

class CategoryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository(), fenix: true);
    final id = Get.parameters['id'] ?? '';
    Get.put<CategoryProductsController>(
      CategoryProductsController(id: id),
      tag: 'cat_$id',
    );
  }
}
