import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import 'models/coupon_model.dart';
import 'models/delivery_option.dart';
import 'models/payment_method_model.dart';
import 'models/place_order_result.dart';

class CheckoutRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<DeliveryOption>> getDeliveryOptions() async {
    final res = await _dio.get(ApiEndpoints.delivery);
    return (res.data as List).map((e) => DeliveryOption.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CouponModel>> getCoupons() async {
    final res = await _dio.get(ApiEndpoints.couponShow);
    return (res.data as List).map((e) => CouponModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final res = await _dio.get(ApiEndpoints.payment);
    return (res.data as List).map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PlaceOrderResult> placeOrder(FormData data) async {
    final res = await _dio.post(ApiEndpoints.placeOrder, data: data);
    return PlaceOrderResult.fromJson(res.data as Map<String, dynamic>);
  }

  Future<bool> updateOrderPayment(String orderId, Map<String, dynamic> body) async {
    final res = await _dio.put('${ApiEndpoints.updateOrderPayment}/$orderId', data: body);
    return (res.data as Map)['success'] == true;
  }
}
