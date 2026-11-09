import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/utils/constants.dart';
import '../models/chat_message_model.dart';
import '../support_chat_repository.dart';

/// Ports reacttemplate's SupportChat.jsx. One real improvement over the web
/// version: the browser `WebSocket` API can't set custom headers, so the web
/// client sends `supportId` as a query param — but the backend
/// (`chatSocket.js`) only ever reads `req.headers['supportid']`, meaning the
/// web app's socket connects with no identifier and real-time push never
/// actually works there (it falls back to a REST POST per message with no
/// live incoming updates). `web_socket_channel`'s IO client CAN set headers,
/// so this client sends `supportid` correctly and gets real bidirectional
/// live chat.
class SupportChatController extends GetxController {
  final SupportChatRepository _repository = Get.find<SupportChatRepository>();
  final GetStorage _box = GetStorage();

  final RxBool isOpen = false.obs;
  final RxBool isFormSubmitted = false.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isSending = false.obs;

  String? _supportId;
  WebSocketChannel? _channel;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<String>(AppConstants.supportUserKey);
    if (saved != null) {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      final email = (data['email'] as String?)?.trim().toLowerCase() ?? '';
      if (email.isNotEmpty) {
        _supportId = email;
        isFormSubmitted.value = true;
        _connect();
      }
    }
  }

  void toggleOpen() => isOpen.value = !isOpen.value;

  Future<void> submitForm() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;

    _supportId = email.toLowerCase();
    isFormSubmitted.value = true;
    await _box.write(AppConstants.supportUserKey, jsonEncode({'name': name, 'email': email}));
    _connect();
  }

  Future<void> _connect() async {
    final supportId = _supportId;
    if (supportId == null) return;

    try {
      messages.value = await _repository.fetchMessages(supportId);
    } catch (_) {}

    _channel?.sink.close();
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(AppConstants.chatWsUrl),
        headers: {'supportid': supportId},
      );
      _channel!.stream.listen(
        (data) {
          final decoded = jsonDecode(data as String);
          if (decoded is List) {
            messages.value = decoded.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
          } else if (decoded is Map) {
            final msg = ChatMessageModel.fromJson(decoded as Map<String, dynamic>);
            final exists = messages.any((m) => m.time == msg.time && m.text == msg.text);
            if (!exists) messages.add(msg);
          }
        },
        onError: (_) {},
        cancelOnError: false,
      );
    } catch (_) {}
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final supportId = _supportId;
    if (text.isEmpty || supportId == null || isSending.value) return;

    final message = ChatMessageModel(
      supportId: supportId,
      bId: emailController.text.trim(),
      bName: nameController.text.trim(),
      text: text,
      sender: 'user',
      time: DateTime.now(),
    );

    isSending.value = true;
    try {
      final saved = await _repository.sendMessage(message);
      _channel?.sink.add(jsonEncode(saved.toJson()));
      messages.add(saved);
      messageController.clear();
    } catch (_) {
      // fire-and-forget, matches web behavior of not surfacing send failures
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    _channel?.sink.close();
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
