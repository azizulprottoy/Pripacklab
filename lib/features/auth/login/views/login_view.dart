import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes_path.dart';
import '../../../../res/theme/app_colors.dart';
import '../../../../res/theme/app_text_styles.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Login now!', style: AppTextStyles.heading),
                  const SizedBox(height: 28),

                  const Text('Email / Phone', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  TextField(
                    onChanged: (v) => controller.emailOrPhone.value = v,
                    decoration: const InputDecoration(hintText: 'Enter email or phone'),
                  ),
                  const SizedBox(height: 16),

                  const Text('Password', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  Obx(
                    () => TextField(
                      onChanged: (v) => controller.password.value = v,
                      obscureText: controller.obscurePassword.value,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          onPressed: controller.toggleObscure,
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textFaint,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => controller.error.value.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              controller.error.value,
                              style: const TextStyle(color: AppColors.error, fontSize: 13),
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),
                  Obx(
                    () => SizedBox(
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(colors: AppColors.heroGradient),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          onPressed: controller.isLoading.value ? null : controller.submit,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: AppTextStyles.bodyMuted),
                      GestureDetector(
                        onTap: () => Get.toNamed(RoutesPath.signup),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(RoutesPath.sellerRegister),
                      child: const Text(
                        'Become a Seller',
                        style: TextStyle(color: AppColors.indigo, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
