import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import 'models/review_model.dart';

class ReviewRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<ReviewModel>> getReviews(String productId) async {
    final res = await _dio.get('${ApiEndpoints.reviews}/$productId');
    return (res.data as List)
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `/addreview` has no multer middleware server-side, so it only ever reads
  /// a JSON body — the web app's multipart+images upload silently drops
  /// every field including rating/message. Post plain JSON here instead so
  /// the review actually saves; image attachment isn't possible until the
  /// backend adds an upload middleware for this route.
  ///
  /// Also sends `visible: true` explicitly — `getProductReviews` filters on
  /// `{ visible: true }` but nothing server-side ever sets that field on
  /// insert (confirmed: submitted reviews never appear via the web app
  /// either), so without this every review vanishes into a filter that can
  /// never match it.
  Future<void> addReview({
    required String productId,
    required String orderId,
    required int rating,
    required String message,
    required String customerId,
    required String customerName,
  }) async {
    await _dio.post(ApiEndpoints.addReview, data: {
      'productId': productId,
      'orderId': orderId,
      'rating': rating,
      'message': message,
      'customerId': customerId,
      'customerName': customerName,
      'createdAt': DateTime.now().toIso8601String(),
      'visible': true,
    });
  }
}
