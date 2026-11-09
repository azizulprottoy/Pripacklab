import 'package:get/get.dart';

import '../../../shared/models/product_model.dart';
import '../../../shared/repositories/product_repository.dart';

class ProductSearchController extends GetxController {
  final ProductRepository _repository = Get.find<ProductRepository>();

  final RxBool isLoading = true.obs;
  final RxString query = ''.obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;

  List<ProductModel> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return [];
    return allProducts.where((p) {
      return p.productName.toLowerCase().contains(q) || p.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      allProducts.value = await _repository.getProducts();
    } finally {
      isLoading.value = false;
    }
  }

  void setQuery(String value) => query.value = value;
}
