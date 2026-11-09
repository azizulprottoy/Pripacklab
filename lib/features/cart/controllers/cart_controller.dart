import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/constants.dart';
import '../models/cart_item.dart';

/// App-wide cart state, GetStorage-backed — mirrors reacttemplate's
/// localStorage 'cart' + 'buyNowItem'. Registered permanent in main() so
/// any screen (product details, bottom nav badge, checkout) can react to it.
class CartController extends GetxController {
  final GetStorage _box = GetStorage();
  final RxList<CartItem> items = <CartItem>[].obs;

  /// Set when "Buy Now" is used — checkout should use just this item
  /// instead of the full cart, then clear it.
  CartItem? buyNowItem;

  int get count => items.length;

  double get totalPrice => items.fold(0, (sum, item) => sum + item.lineTotal);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = _box.read<List>(AppConstants.cartStorageKey);
    if (raw == null) return;
    items.value = raw
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _persist() async {
    await _box.write(AppConstants.cartStorageKey, items.map((e) => e.toJson()).toList());
  }

  bool isAlreadyAdded(String productId, String label) {
    return items.any((i) => i.productId == productId && i.label == label);
  }

  Future<void> addItem(CartItem item) async {
    items.add(item);
    await _persist();
  }

  Future<void> updateUnits(int index, int delta) async {
    final item = items[index];
    item.units = (item.units + delta).clamp(1, 999);
    items.refresh();
    await _persist();
  }

  Future<void> removeAt(int index) async {
    items.removeAt(index);
    await _persist();
  }

  Future<void> clear() async {
    items.clear();
    await _persist();
  }

  void setBuyNow(CartItem item) => buyNowItem = item;

  void clearBuyNow() => buyNowItem = null;
}
