import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/theme/app_colors.dart';
import '../../../../res/theme/app_text_styles.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Account Type', style: AppTextStyles.label),
              const SizedBox(height: 6),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.accountType.value.isEmpty
                      ? null
                      : controller.accountType.value,
                  hint: const Text('Select One'),
                  items: SignupController.accountTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => controller.accountType.value = v ?? '',
                ),
              ),
              const SizedBox(height: 14),

              _label('Name'),
              TextField(
                onChanged: (v) => controller.name.value = v,
                decoration: const InputDecoration(hintText: 'Enter your Name'),
              ),
              const SizedBox(height: 14),

              _label('Email'),
              TextField(
                onChanged: (v) => controller.email.value = v,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              Obx(
                () => controller.email.value.isNotEmpty && !controller.emailValid
                    ? _errorText('Please enter a valid email address')
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 14),

              _label('Phone'),
              TextField(
                onChanged: (v) => controller.phone.value = v,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'e.g. 01XXXXXXXXX'),
              ),
              Obx(
                () => controller.phone.value.isNotEmpty && !controller.phoneValid
                    ? _errorText('Please enter a valid Bangladeshi phone number (e.g. 01XXXXXXXXX)')
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 14),

              _label('Address'),
              TextField(
                onChanged: (v) => controller.address.value = v,
                decoration: const InputDecoration(hintText: 'Enter your full address'),
              ),
              const SizedBox(height: 14),

              _label('Password'),
              TextField(
                onChanged: (v) => controller.password.value = v,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Enter a password'),
              ),
              const SizedBox(height: 14),

              _label('Retype Password'),
              TextField(
                onChanged: (v) => controller.rePassword.value = v,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Re-enter password'),
              ),
              Obx(
                () => controller.rePassword.value.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          controller.passwordsMatch ? 'Passwords match' : 'Passwords do not match',
                          style: TextStyle(
                            fontSize: 13,
                            color: controller.passwordsMatch ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.canSubmit && !controller.isLoading.value
                      ? controller.submit
                      : null,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Sign Up'),
                ),
              ),

              Obx(
                () => controller.message.value.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          controller.message.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error, fontSize: 13),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTextStyles.label),
      );

  Widget _errorText(String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(text, style: const TextStyle(color: AppColors.error, fontSize: 12)),
      );
}
