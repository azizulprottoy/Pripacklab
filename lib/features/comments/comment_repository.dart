import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import 'models/comment_model.dart';

class CommentRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  /// GET /comments/:productId returns ALL statuses — filter status=='show'
  /// client-side (backend doesn't do it server-side).
  Future<List<CommentModel>> getComments(String productId) async {
    final res = await _dio.get('${ApiEndpoints.comments}/$productId');
    return (res.data as List)
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .where((c) => c.status == 'show')
        .toList();
  }

  Future<void> addComment({
    required String productId,
    required String userName,
    required String message,
  }) async {
    await _dio.post(
      ApiEndpoints.addComment,
      data: {'productId': productId, 'userName': userName, 'message': message},
    );
  }

  Future<void> likeComment(String commentId) async {
    await _dio.patch('${ApiEndpoints.likeComment}/$commentId');
  }

  Future<void> replyComment({
    required String commentId,
    required String userName,
    required String message,
  }) async {
    await _dio.post(
      '${ApiEndpoints.replyComment}/$commentId',
      data: {'userName': userName, 'message': message},
    );
  }

  Future<void> likeReply(String commentId, String replyId) async {
    await _dio.patch('${ApiEndpoints.likeReply}/$commentId/$replyId');
  }
}
