import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../controllers/support_chat_controller.dart';

class SupportChatOverlay extends StatelessWidget {
  const SupportChatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportChatController>();

    return Positioned(
      right: 16,
      bottom: 90,
      child: Obx(() {
        if (!controller.isOpen.value) {
          return FloatingActionButton(
            heroTag: 'support_chat_fab',
            onPressed: controller.toggleOpen,
            backgroundColor: AppColors.indigo,
            child: const Icon(Icons.chat_bubble_outline),
          );
        }

        return Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 320,
            height: 420,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  color: AppColors.indigo,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Support Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: controller.toggleOpen,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => controller.isFormSubmitted.value ? _chatBody(controller) : _formBody(controller)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _formBody(SupportChatController controller) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please enter your details before starting chat:', style: AppTextStyles.bodyMuted),
          const SizedBox(height: 10),
          TextField(controller: controller.nameController, decoration: const InputDecoration(hintText: 'Your Name', isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: controller.emailController, decoration: const InputDecoration(hintText: 'Your Email', isDense: true)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: controller.submitForm, child: const Text('Start Chat')),
          ),
        ],
      ),
    );
  }

  Widget _chatBody(SupportChatController controller) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.messages.isEmpty) {
              return const Center(child: Text('Start your conversation below', style: AppTextStyles.bodyMuted));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final msg = controller.messages[index];
                final isUser = msg.sender == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    constraints: const BoxConstraints(maxWidth: 220),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text, style: AppTextStyles.body),
                  ),
                );
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  decoration: const InputDecoration(hintText: 'Type your message…', isDense: true),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: controller.isSending.value ? null : controller.sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
