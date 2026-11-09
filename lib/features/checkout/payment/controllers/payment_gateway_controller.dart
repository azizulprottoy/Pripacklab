import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes_path.dart';
import '../../../../shared/widgets/snack_message.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../checkout_repository.dart';
import '../../models/payment_method_model.dart';

/// Ports reacttemplate's paymentGateway.jsx — reference code display, payment
/// method selection, and transaction-ID confirmation against
/// PUT /updateorderpayment/:id.
class PaymentGatewayController extends GetxController {
  final CheckoutRepository _repository = Get.find<CheckoutRepository>();
  final CartController _cart = Get.find<CartController>();

  late final String orderId;
  late final double subtotal;
  late final double deliveryCharge;
  late final double discount;
  late final double totalPrice;
  late final String refCode;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;
  final Rxn<PaymentMethodModel> selectedMethod = Rxn<PaymentMethodModel>();
  final TextEditingController transactionIdController = TextEditingController();
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments is Map ? Get.arguments as Map : const {};
    orderId = args['orderId']?.toString() ?? '';
    subtotal = (args['subtotal'] as num?)?.toDouble() ?? 0;
    deliveryCharge = (args['deliveryCharge'] as num?)?.toDouble() ?? 0;
    discount = (args['discount'] as num?)?.toDouble() ?? 0;
    totalPrice = (args['totalPrice'] as num?)?.toDouble() ?? 0;
    refCode = _generateRefCode();

    if (orderId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed(RoutesPath.shell));
      return;
    }
    _fetchMethods();
  }

  String _generateRefCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const digits = '123456789';
    final rand = Random();
    final l1 = letters[rand.nextInt(letters.length)];
    final l2 = letters[rand.nextInt(letters.length)];
    final nums = List.generate(4, (_) => digits[rand.nextInt(digits.length)]).join();
    return '$l1$l2$nums';
  }

  Future<void> _fetchMethods() async {
    isLoading.value = true;
    try {
      final methods = await _repository.getPaymentMethods();
      paymentMethods.value = methods;
      if (methods.isNotEmpty) selectedMethod.value = methods.first;
    } catch (_) {
      // Non-fatal — mirrors the web page's console.error-and-continue behavior.
    } finally {
      isLoading.value = false;
    }
  }

  void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackMessage.showSuccess('Copied to clipboard');
  }

  Future<void> confirmPayment() async {
    final method = selectedMethod.value;
    if (method == null) {
      error.value = 'Please select a payment method.';
      return;
    }
    if (transactionIdController.text.trim().isEmpty) {
      error.value = 'Please enter your transaction ID.';
      return;
    }
    error.value = '';
    isSubmitting.value = true;
    try {
      final ok = await _repository.updateOrderPayment(orderId, {
        'paymentMethod': method.method,
        'paymentNumber': method.number,
        'referenceCode': refCode,
        'transactionId': transactionIdController.text.trim(),
        'paymentStatus': 'Pending Verification',
      });
      if (ok) {
        await _cart.clear();
        _cart.clearBuyNow();
        Get.offAllNamed(RoutesPath.shell);
        SnackMessage.showSuccess('Payment submitted — we will verify it within 24 hours.');
      } else {
        error.value = 'Failed to update payment. Please try again.';
      }
    } catch (_) {
      error.value = 'Server error. Please try again.';
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    transactionIdController.dispose();
    super.onClose();
  }
}
