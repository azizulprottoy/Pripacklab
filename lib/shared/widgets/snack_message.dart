import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/theme/app_colors.dart';

class SnackMessage {
  SnackMessage._();

  static void showSuccess(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.success.withValues(alpha: 0.12),
      colorText: AppColors.textDark,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void showError(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error.withValues(alpha: 0.12),
      colorText: AppColors.textDark,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warning.withValues(alpha: 0.12),
      colorText: AppColors.textDark,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
