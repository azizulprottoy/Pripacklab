import 'package:get/get.dart';

import '../../../shared/widgets/snack_message.dart';
import '../../auth/auth_controller.dart';
import '../../orders/models/order_model.dart';
import '../seller_repository.dart';

class SellerOrdersController extends GetxController {
  final SellerRepository _repository = Get.find<SellerRepository>();
  final AuthController _auth = Get.find<AuthController>();

  static const statusOptions = ['Placed', 'Confirmed', 'On Making', 'On Transit', 'Delivered'];
  static const paymentOptions = ['pending', 'Paid', 'Failed'];

  final RxBool isLoading = true.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  String get sellerId => _auth.user.value?.userId ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    if (sellerId.isEmpty) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      orders.value = await _repository.getSellerOrders(sellerId);
    } catch (_) {
      orders.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderCartItem> sellerItems(OrderModel order) =>
      order.cartItems.where((i) => i.sellerId == sellerId).toList();

  double sellerTotal(OrderModel order) =>
      sellerItems(order).fold(0.0, (sum, i) => sum + i.selectedPrice * i.units);

  Future<void> updateStatus(String orderId, String status) async {
    try {
      await _repository.updateOrderStatus(orderId, status);
      SnackMessage.showSuccess('Order status updated.');
      fetchOrders();
    } catch (_) {
      SnackMessage.showError('Failed to update status.');
    }
  }

  Future<void> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      await _repository.updateOrderPaymentStatus(orderId, paymentStatus);
      SnackMessage.showSuccess('Payment status updated.');
      fetchOrders();
    } catch (_) {
      SnackMessage.showError('Failed to update payment status.');
    }
  }
}
