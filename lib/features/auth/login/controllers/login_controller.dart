import 'package:get/get.dart';

import '../../../../app/routes/routes_path.dart';
import '../../auth_controller.dart';

class LoginController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxString emailOrPhone = ''.obs;
  final RxString password = ''.obs;
  final RxBool obscurePassword = true.obs;
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  Future<void> submit() async {
    if (emailOrPhone.value.trim().isEmpty || password.value.trim().isEmpty) {
      error.value = 'Please enter both fields';
      return;
    }

    error.value = '';
    isLoading.value = true;
    final failureMessage = await _authController.login(
      emailOrPhone: emailOrPhone.value.trim(),
      password: password.value,
    );
    isLoading.value = false;

    if (failureMessage != null) {
      error.value = failureMessage;
      return;
    }

    if (_authController.isSeller) {
      Get.offAllNamed(RoutesPath.sellerProfile);
    } else {
      Get.offAllNamed(RoutesPath.shell);
    }
  }
}
