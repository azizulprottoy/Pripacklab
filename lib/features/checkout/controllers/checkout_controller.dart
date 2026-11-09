import 'dart:convert';

import 'package:dio/dio.dart' show FormData, MultipartFile, DioException;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../app/routes/routes_path.dart';
import '../../../shared/widgets/snack_message.dart';
import '../../auth/auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/models/cart_item.dart';
import '../checkout_repository.dart';
import '../models/coupon_model.dart';
import '../models/delivery_option.dart';

class UnitEntry {
  final TextEditingController descriptionController = TextEditingController();
  final Rxn<PlatformFile> file = Rxn<PlatformFile>();
}

/// Ports reacttemplate's Checkout.jsx — buyer info, per-unit description +
/// optional attachment, delivery option, coupon, and Cash-on-Delivery vs
/// Pay-Now submission to POST /placeorder (multipart).
class CheckoutController extends GetxController {
  final CheckoutRepository _repository = Get.find<CheckoutRepository>();
  final CartController _cart = Get.find<CartController>();

  late final List<CartItem> cartItems;
  late final double subtotal;
  late final List<List<UnitEntry>> unitEntries;

  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerEmailController = TextEditingController();
  final TextEditingController buyerPhoneController = TextEditingController();
  final TextEditingController buyerAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController couponInputController = TextEditingController();

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxList<DeliveryOption> deliveryOptions = <DeliveryOption>[].obs;
  final Rxn<DeliveryOption> selectedDelivery = Rxn<DeliveryOption>();
  final Rxn<CouponModel> appliedCoupon = Rxn<CouponModel>();
  final RxString couponError = ''.obs;
  List<CouponModel> _coupons = [];

  bool get isLoggedIn => Get.find<AuthController>().isLoggedIn;
  double get deliveryCharge => selectedDelivery.value?.charge ?? 0;

  double get discountAmount {
    final coupon = appliedCoupon.value;
    if (coupon == null) return 0;
    final base = subtotal + deliveryCharge;
    if (coupon.discountType == 'fixed') {
      return coupon.maxAmount != null ? [coupon.discount, coupon.maxAmount!].reduce((a, b) => a < b ? a : b) : coupon.discount;
    }
    final pct = base * coupon.discount / 100;
    return coupon.maxAmount != null ? (pct < coupon.maxAmount! ? pct : coupon.maxAmount!) : pct;
  }

  double get totalPrice => (subtotal + deliveryCharge - discountAmount).clamp(0, double.infinity);

  @override
  void onInit() {
    super.onInit();
    final buyNow = _cart.buyNowItem;
    cartItems = buyNow != null ? [buyNow] : List<CartItem>.from(_cart.items);
    subtotal = cartItems.fold(0.0, (sum, i) => sum + i.lineTotal);
    unitEntries = [for (final item in cartItems) List.generate(item.units, (_) => UnitEntry())];

    final user = Get.find<AuthController>().user.value;
    if (user != null) {
      buyerNameController.text = user.name;
      buyerEmailController.text = user.email;
      buyerPhoneController.text = user.phone;
      buyerAddressController.text = user.address ?? '';
    }

    _fetchOptions();
  }

  Future<void> _fetchOptions() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.getDeliveryOptions(),
        _repository.getCoupons(),
      ]);
      deliveryOptions.value = results[0] as List<DeliveryOption>;
      _coupons = results[1] as List<CouponModel>;
    } catch (_) {
      // Non-fatal — mirrors the web page's console.error-and-continue behavior.
    } finally {
      isLoading.value = false;
    }
  }

  void applyCoupon() {
    couponError.value = '';
    appliedCoupon.value = null;

    final code = couponInputController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    CouponModel? found;
    for (final c in _coupons) {
      if (c.couponCode.toUpperCase() == code) {
        found = c;
        break;
      }
    }
    if (found == null) {
      couponError.value = 'Invalid coupon code.';
      return;
    }
    if (found.couponDate != null && found.couponDate!.isBefore(DateTime.now())) {
      couponError.value = 'This coupon has expired.';
      return;
    }
    if (found.remaining != null && found.remaining! <= 0) {
      couponError.value = 'This coupon is fully redeemed.';
      return;
    }
    if (found.minSpent != null && subtotal < found.minSpent!) {
      couponError.value = 'Minimum order ৳${found.minSpent} required.';
      return;
    }
    appliedCoupon.value = found;
  }

  void removeCoupon() {
    appliedCoupon.value = null;
    couponInputController.clear();
    couponError.value = '';
  }

  Future<void> pickUnitFile(int pi, int ui) async {
    final file = await FilePicker.pickFile();
    if (file != null) {
      unitEntries[pi][ui].file.value = file;
    }
  }

  bool _validate() {
    if (buyerNameController.text.trim().isEmpty ||
        buyerPhoneController.text.trim().isEmpty ||
        buyerAddressController.text.trim().isEmpty) {
      SnackMessage.showError('Please fill all required fields!');
      return false;
    }
    if (!isLoggedIn) {
      if (passwordController.text.isEmpty) {
        SnackMessage.showError('Please enter a password.');
        return false;
      }
      if (passwordController.text != rePasswordController.text) {
        SnackMessage.showError('Passwords do not match!');
        return false;
      }
    }
    if (selectedDelivery.value == null) {
      SnackMessage.showError('Please select a delivery option!');
      return false;
    }
    for (var pi = 0; pi < unitEntries.length; pi++) {
      for (var ui = 0; ui < unitEntries[pi].length; ui++) {
        if (unitEntries[pi][ui].descriptionController.text.trim().isEmpty) {
          SnackMessage.showError(
            'Please fill the description for "${cartItems[pi].productName}" - Unit ${ui + 1}',
          );
          return false;
        }
      }
    }
    return true;
  }

  Future<FormData> _buildFormData({required bool payNow}) async {
    final cartItemsJson = [
      for (var pi = 0; pi < cartItems.length; pi++)
        {
          ...cartItems[pi].toJson(),
          'unitDetails': [
            for (var ui = 0; ui < unitEntries[pi].length; ui++)
              {
                'description': unitEntries[pi][ui].descriptionController.text.trim(),
                'fileName': unitEntries[pi][ui].file.value?.name,
              },
          ],
        },
    ];

    final formData = FormData.fromMap({
      'buyerName': buyerNameController.text.trim(),
      'buyerEmail': buyerEmailController.text.trim(),
      'buyerPhone': buyerPhoneController.text.trim(),
      'buyerAddress': buyerAddressController.text.trim(),
      'totalPrice': totalPrice.toString(),
      'subtotal': subtotal.toString(),
      'deliveryCharge': deliveryCharge.toString(),
      'deliveryArea': selectedDelivery.value?.area ?? '',
      'deliveryPeriod': selectedDelivery.value?.period ?? '',
      'coupon': appliedCoupon.value?.couponCode ?? '',
      'discount': discountAmount.toString(),
      'loggedIn': isLoggedIn.toString(),
      if (!isLoggedIn) 'password': passwordController.text,
      if (payNow) 'paymentMethod': 'Online Payment',
      'cartItems': jsonEncode(cartItemsJson),
    });

    for (var pi = 0; pi < unitEntries.length; pi++) {
      for (var ui = 0; ui < unitEntries[pi].length; ui++) {
        final file = unitEntries[pi][ui].file.value;
        if (file != null && file.path != null) {
          formData.files.add(MapEntry(
            'unit_file_${pi}_$ui',
            await MultipartFile.fromFile(file.path!, filename: file.name),
          ));
        }
      }
    }

    return formData;
  }

  Future<void> submitOrder({required bool payNow}) async {
    if (!_validate()) return;

    isSubmitting.value = true;
    try {
      final formData = await _buildFormData(payNow: payNow);
      final result = await _repository.placeOrder(formData);

      if (result.exists) {
        SnackMessage.showError('This phone number already has an account. Please login first!');
        return;
      }
      if (!result.success) {
        SnackMessage.showError('Failed to place order!');
        return;
      }

      await _cart.clear();
      _cart.clearBuyNow();

      if (payNow) {
        Get.offNamed(RoutesPath.paymentGateway, arguments: {
          'orderId': result.orderId,
          'subtotal': subtotal,
          'deliveryCharge': deliveryCharge,
          'discount': discountAmount,
          'totalPrice': totalPrice,
        });
      } else {
        Get.defaultDialog(
          title: 'Order Confirmation',
          middleText: 'Thank you! You will receive an order confirmation call soon.',
          textConfirm: 'Continue Shopping',
          barrierDismissible: false,
          onConfirm: () {
            Get.back();
            Get.offAllNamed(RoutesPath.shell);
          },
        );
      }
    } on DioException {
      SnackMessage.showError('Server error!');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    buyerNameController.dispose();
    buyerEmailController.dispose();
    buyerPhoneController.dispose();
    buyerAddressController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    couponInputController.dispose();
    for (final list in unitEntries) {
      for (final e in list) {
        e.descriptionController.dispose();
      }
    }
    super.onClose();
  }
}
