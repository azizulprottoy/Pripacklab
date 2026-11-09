import 'package:get/get.dart';

import '../../../app/routes/routes_path.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 700));
    Get.offAllNamed(RoutesPath.shell);
  }
}
