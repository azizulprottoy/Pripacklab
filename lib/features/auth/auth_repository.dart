import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AuthRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  /// POST /customerlogin — works for both customer and seller accounts.
  /// Returns `{ success, message, token, user }`.
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final res = await _dio.post(
      ApiEndpoints.customerLogin,
      data: {'emailOrPhone': emailOrPhone, 'password': password},
    );
    return res.data as Map<String, dynamic>;
  }

  /// POST /addcustomer — raw passthrough insert, no response wrapper.
  Future<void> signupCustomer(Map<String, dynamic> payload) async {
    await _dio.post(ApiEndpoints.addCustomer, data: payload);
  }

  /// POST /addseller — raw passthrough insert.
  Future<void> registerSeller(Map<String, dynamic> payload) async {
    await _dio.post(ApiEndpoints.addSeller, data: payload);
  }
}
