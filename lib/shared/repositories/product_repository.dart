import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../features/product_details/models/product_details_response.dart';
import '../models/product_model.dart';

class ProductRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<ProductModel>> getProducts() async {
    final res = await _dio.get(ApiEndpoints.getProducts);
    return (res.data as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductDetailsResponse> getProductDetails(String id) async {
    final res = await _dio.get('${ApiEndpoints.productDetails}/$id');
    return ProductDetailsResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
