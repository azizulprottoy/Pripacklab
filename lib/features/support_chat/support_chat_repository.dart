import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import 'models/chat_message_model.dart';

class SupportChatRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<ChatMessageModel>> fetchMessages(String supportId) async {
    final res = await _dio.get('${ApiEndpoints.schat}/$supportId');
    return (res.data as List).map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Returns the server's canonical stored copy (its response echoes the
  /// inserted document) rather than the locally-built one, so the caller can
  /// re-broadcast/dedupe against a `time` value guaranteed identical to what
  /// the WS broadcast for this same message will carry.
  Future<ChatMessageModel> sendMessage(ChatMessageModel message) async {
    final res = await _dio.post(ApiEndpoints.addSchat, data: message.toJson());
    return ChatMessageModel.fromJson(res.data as Map<String, dynamic>);
  }
}
