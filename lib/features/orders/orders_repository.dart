import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import 'models/order_model.dart';

class OrdersRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<OrderModel>> getCustomerOrders(String customerId) async {
    final res = await _dio.get('${ApiEndpoints.getOrders}/$customerId');
    final orders = (res.data as Map<String, dynamic>)['orders'] as List? ?? [];
    return orders.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
