import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../orders/models/order_model.dart';
import '../../shared/models/category_model.dart';
import '../../shared/models/product_model.dart';
import 'models/subcategory_model.dart';

class CategoriesAndSubcategories {
  final List<CategoryModel> categories;
  final List<SubcategoryModel> subcategories;

  CategoriesAndSubcategories({required this.categories, required this.subcategories});
}

/// Backend gap fixed as part of this port: `/sellerproducts/:id`,
/// `/sellerorders/:id` and `PATCH /order/paymentstatus/:id` did not exist at
/// all server-side (the web app's SellerProductCrud/SellerOrders call them
/// but always silently get nothing) — added minimal handlers in
/// reacttempletebackend for all three, plus persisted sellerId/sellerName on
/// addProduct/editProduct (previously accepted but dropped).
class SellerRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<ProductModel>> getSellerProducts(String sellerId) async {
    final res = await _dio.get('${ApiEndpoints.sellerProducts}/$sellerId');
    final products = (res.data as Map<String, dynamic>)['products'] as List? ?? [];
    return products.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CategoriesAndSubcategories> getCategoriesAndSubcategories() async {
    final res = await _dio.get(ApiEndpoints.getCatNSub);
    final data = res.data as Map<String, dynamic>;
    return CategoriesAndSubcategories(
      categories: (data['categories'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subcategories: (data['subcategories'] as List? ?? [])
          .map((e) => SubcategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> addProduct(FormData data) async {
    await _dio.post(ApiEndpoints.addProduct, data: data);
  }

  Future<void> editProduct(String id, FormData data) async {
    await _dio.put('${ApiEndpoints.editProduct}/$id', data: data);
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete('${ApiEndpoints.delProduct}/$id');
  }

  Future<List<OrderModel>> getSellerOrders(String sellerId) async {
    final res = await _dio.get('${ApiEndpoints.sellerOrders}/$sellerId');
    final orders = (res.data as Map<String, dynamic>)['orders'] as List? ?? [];
    return orders.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _dio.patch('${ApiEndpoints.orderStatus}/$orderId', data: {
      'status': status,
      'note': 'Seller updated status to $status',
    });
  }

  Future<void> updateOrderPaymentStatus(String orderId, String paymentStatus) async {
    await _dio.patch('${ApiEndpoints.orderPaymentStatus}/$orderId', data: {
      'paymentStatus': paymentStatus,
      'payment': paymentStatus,
    });
  }
}
