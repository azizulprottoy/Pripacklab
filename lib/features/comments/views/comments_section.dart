import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../controllers/comments_controller.dart';

class CommentsSection extends StatelessWidget {
  final String productId;

  const CommentsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommentsController>(tag: 'product_$productId');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comments', style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => controller.newComment.value = v,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Write a comment...'),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: controller.addComment,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              child: const Text('Comment'),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: controller.comments.map((comment) {
                final isReplying = controller.activeReplyId.value == comment.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            if (comment.createdAt != null)
                              Text(
                                DateFormat.yMMMd().format(comment.createdAt!),
                                style: AppTextStyles.bodyMuted.copyWith(fontSize: 11),
                              ),
                            const SizedBox(height: 6),
                            Text(comment.message, style: AppTextStyles.body),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => controller.likeComment(comment.id),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.thumb_up_outlined, size: 14, color: AppColors.textMuted),
                                      const SizedBox(width: 4),
                                      Text('${comment.likes}', style: AppTextStyles.bodyMuted),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () => controller.toggleReply(comment.id),
                                  child: const Text('Reply', style: AppTextStyles.bodyMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isReplying)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 8),
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (v) => controller.replyText.value = v,
                                decoration: const InputDecoration(hintText: 'Write a reply...'),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => controller.addReply(comment.id),
                                  child: const Text('Post Reply'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (comment.replies.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 4),
                          child: Column(
                            children: comment.replies.map((reply) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reply.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(reply.message, style: AppTextStyles.body),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () => controller.likeReply(comment.id, reply.id),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.thumb_up_outlined, size: 12, color: AppColors.textMuted),
                                          const SizedBox(width: 4),
                                          Text('${reply.likes}', style: AppTextStyles.bodyMuted),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
