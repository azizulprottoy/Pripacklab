import 'package:get/get.dart';

import '../../../../app/routes/routes_path.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/snack_message.dart';
import '../../auth_repository.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  static const accountTypes = ['Individual', 'Startup', 'Corporate Office'];

  final RxString accountType = ''.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString address = ''.obs;
  final RxString password = ''.obs;
  final RxString rePassword = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;

  bool get emailValid => email.value.isEmpty || isValidEmail(email.value);
  bool get phoneValid => phone.value.isEmpty || isValidPhone(phone.value);
  bool get passwordsMatch =>
      password.value.isNotEmpty && rePassword.value.isNotEmpty && password.value == rePassword.value;

  bool get canSubmit =>
      accountType.value.isNotEmpty &&
      name.value.trim().isNotEmpty &&
      address.value.trim().isNotEmpty &&
      isValidEmail(email.value) &&
      isValidPhone(phone.value) &&
      passwordsMatch;

  Future<void> submit() async {
    if (!isValidEmail(email.value)) {
      message.value = 'Please enter a valid email address.';
      return;
    }
    if (!isValidPhone(phone.value)) {
      message.value = 'Please enter a valid Bangladeshi phone number (e.g. 01XXXXXXXXX).';
      return;
    }
    if (password.value != rePassword.value) {
      message.value = 'Passwords do not match!';
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.signupCustomer({
        'accountType': accountType.value,
        'name': name.value.trim(),
        'email': email.value.trim(),
        'phone': phone.value.trim(),
        'address': address.value.trim(),
        'password': password.value,
      });
      SnackMessage.showSuccess('Registration successful! You can now log in.');
      Get.offAllNamed(RoutesPath.login);
    } catch (e) {
      message.value = 'Signup failed. Try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
