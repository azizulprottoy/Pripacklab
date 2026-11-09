import 'package:get/get.dart';

import '../../../shared/widgets/snack_message.dart';
import '../comment_repository.dart';
import '../models/comment_model.dart';

class CommentsController extends GetxController {
  final CommentRepository _repository = Get.find<CommentRepository>();
  final String productId;

  CommentsController({required this.productId});

  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString newComment = ''.obs;
  final RxString replyText = ''.obs;
  final Rxn<String> activeReplyId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      comments.value = await _repository.getComments(productId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment() async {
    if (newComment.value.trim().isEmpty) return;
    try {
      await _repository.addComment(
        productId: productId,
        userName: 'Guest User',
        message: newComment.value.trim(),
      );
      newComment.value = '';
      await fetch();
    } catch (_) {
      SnackMessage.showError('Failed to post comment');
    }
  }

  void toggleReply(String commentId) {
    activeReplyId.value = activeReplyId.value == commentId ? null : commentId;
    replyText.value = '';
  }

  Future<void> addReply(String commentId) async {
    if (replyText.value.trim().isEmpty) return;
    try {
      await _repository.replyComment(
        commentId: commentId,
        userName: 'Guest User',
        message: replyText.value.trim(),
      );
      replyText.value = '';
      activeReplyId.value = null;
      await fetch();
    } catch (_) {
      SnackMessage.showError('Failed to post reply');
    }
  }

  Future<void> likeComment(String commentId) async {
    await _repository.likeComment(commentId);
    await fetch();
  }

  Future<void> likeReply(String commentId, String replyId) async {
    await _repository.likeReply(commentId, replyId);
    await fetch();
  }
}
