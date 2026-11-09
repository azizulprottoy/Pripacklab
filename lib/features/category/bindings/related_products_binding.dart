import 'package:get/get.dart';

import '../../../shared/repositories/category_repository.dart';
import '../controllers/category_products_controller.dart';

class RelatedProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository(), fenix: true);
    final catname = Get.parameters['catname'] ?? '';
    Get.put<CategoryProductsController>(
      CategoryProductsController(catname: catname),
      tag: 'related_$catname',
    );
  }
}
