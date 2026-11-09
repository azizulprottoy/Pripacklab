import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/category_products_result.dart';

class CategoryRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get(ApiEndpoints.getCat);
    return (res.data as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CategoryProductsResult> getCategoryDetails(String id) async {
    final res = await _dio.get('${ApiEndpoints.categoryDetails}/$id');
    return CategoryProductsResult.fromJson(res.data as Map<String, dynamic>);
  }

  Future<CategoryProductsResult> getRelatedProducts(String catname) async {
    final res = await _dio.get('${ApiEndpoints.relatedProducts}/$catname');
    return CategoryProductsResult.fromJson(res.data as Map<String, dynamic>);
  }
}
