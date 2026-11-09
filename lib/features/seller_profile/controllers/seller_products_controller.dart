import 'package:get/get.dart';

import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/snack_message.dart';
import '../../auth/auth_controller.dart';
import '../seller_repository.dart';

class SellerProductsController extends GetxController {
  final SellerRepository _repository = Get.find<SellerRepository>();
  final AuthController _auth = Get.find<AuthController>();

  final RxBool isLoading = true.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  String get sellerId => _auth.user.value?.userId ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (sellerId.isEmpty) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      products.value = await _repository.getSellerProducts(sellerId);
    } catch (_) {
      products.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      SnackMessage.showSuccess('Product deleted successfully.');
      fetchProducts();
    } catch (_) {
      SnackMessage.showError('Failed to delete product.');
    }
  }
}
