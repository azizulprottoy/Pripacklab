import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/repositories/product_repository.dart';
import '../../../shared/widgets/snack_message.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/models/cart_item.dart';
import 'package:dio/dio.dart' show DioException;

class ProductDetailsController extends GetxController {
  final ProductRepository _repository = Get.find<ProductRepository>();
  final CartController _cart = Get.find<CartController>();
  final String productId;

  ProductDetailsController({required this.productId});

  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final RxList<ProductModel> relatedProducts = <ProductModel>[].obs;
  final Rxn<String> selectedImage = Rxn<String>();
  final RxMap<String, String> selectedCriteria = <String, String>{}.obs;
  final Rxn<VariantModel> selectedVariant = Rxn<VariantModel>();
  final Rx<String?> step1 = Rx<String?>(null);
  final Rx<String?> step2 = Rx<String?>(null);
  final Rx<String?> step3 = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _repository.getProductDetails(productId);
      product.value = res.product;
      relatedProducts.value = res.relatedProducts;
      step1.value = res.process?.step1;
      step2.value = res.process?.step2;
      step3.value = res.process?.step3;

      selectedCriteria.clear();
      selectedVariant.value = null;

      final firstActive = res.product.variants.where((v) => v.isActive);
      if (firstActive.isNotEmpty) {
        final variant = firstActive.first;
        selectedVariant.value = variant;
        selectedCriteria.addAll(variant.combination);
      }

      if (res.product.mainPics.isNotEmpty) {
        selectedImage.value = res.product.imageUrls.first;
      }
    } on DioException {
      error.value = 'Failed to fetch product data';
    } finally {
      isLoading.value = false;
    }
  }

  void selectImage(String url) => selectedImage.value = url;

  void selectCriteria(String criteriaName, String value) {
    selectedCriteria[criteriaName] = value;
    _recomputeVariant();
  }

  void _recomputeVariant() {
    final p = product.value;
    if (p == null || p.criteria.isEmpty) return;

    final criteriaKeys = p.criteria.map((c) => c.name).toList();
    final allSelected = criteriaKeys.every((key) => selectedCriteria.containsKey(key));

    if (!allSelected) {
      selectedVariant.value = null;
      return;
    }

    final matches = p.variants.where(
      (v) => v.isActive && criteriaKeys.every((key) => v.combination[key] == selectedCriteria[key]),
    );
    selectedVariant.value = matches.isEmpty ? null : matches.first;
  }

  /// Whether `value` for `criteriaName` is reachable given everything else
  /// currently selected — used to gray out impossible combinations.
  bool isValueAvailable(String criteriaName, String value) {
    final p = product.value;
    if (p == null) return false;

    return p.variants.any((v) {
      if (!v.isActive) return false;
      if (v.combination[criteriaName] != value) return false;

      return selectedCriteria.entries.every((entry) {
        if (entry.key == criteriaName) return true;
        return v.combination[entry.key] == entry.value;
      });
    });
  }

  void addToCart() {
    final p = product.value;
    final variant = selectedVariant.value;
    if (p == null || variant == null) {
      SnackMessage.showError('Please select all options before adding to cart.');
      return;
    }

    if (_cart.isAlreadyAdded(p.id, variant.label)) {
      SnackMessage.showWarning('This product is already added to your cart.');
      return;
    }

    _cart.addItem(CartItem(
      productId: p.id,
      productName: p.productName,
      selectedImage: selectedImage.value,
      combination: variant.combination,
      label: variant.label,
      selectedPrice: variant.priceValue,
      mainPics: p.mainPics,
      sellerId: p.sellerId,
      sellerName: p.sellerName,
    ));

    SnackMessage.showSuccess('Product added to cart successfully.');
  }

  void buyNow() {
    final p = product.value;
    final variant = selectedVariant.value;
    if (p == null || variant == null) {
      SnackMessage.showError('Please select all options before proceeding.');
      return;
    }

    _cart.setBuyNow(CartItem(
      productId: p.id,
      productName: p.productName,
      selectedImage: selectedImage.value,
      combination: variant.combination,
      label: variant.label,
      selectedPrice: variant.priceValue,
      mainPics: p.mainPics,
      sellerId: p.sellerId,
      sellerName: p.sellerName,
    ));

    Get.toNamed(RoutesPath.checkout);
  }
}
