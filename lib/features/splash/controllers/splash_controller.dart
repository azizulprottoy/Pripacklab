import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';
import '../../auth/auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 700));
    final auth = Get.find<AuthController>();

    if (!auth.isLoggedIn) {
      Get.offAllNamed(RoutesPath.login);
      return;
    }

    if (auth.isSeller) {
      Get.offAllNamed(RoutesPath.sellerProfile);
    } else {
      Get.offAllNamed(RoutesPath.shell);
    }
  }
}
