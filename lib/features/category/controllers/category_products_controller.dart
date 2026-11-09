import 'package:get/get.dart';

import '../../../shared/models/category_model.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/repositories/category_repository.dart';

/// Backs both category-details (by id) and related-products (by catname) —
/// same request/response shape from the backend, just a different key.
class CategoryProductsController extends GetxController {
  final CategoryRepository _repository = Get.find<CategoryRepository>();
  final String? id;
  final String? catname;

  CategoryProductsController({this.id, this.catname});

  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final Rxn<CategoryModel> category = Rxn<CategoryModel>();
  final RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = id != null
          ? await _repository.getCategoryDetails(id!)
          : await _repository.getRelatedProducts(catname!);
      category.value = result.category;
      products.value = result.products;
    } catch (e) {
      error.value = 'Failed to load category.';
    } finally {
      isLoading.value = false;
    }
  }
}
