import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';
import 'core/storage/session_storage.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/auth_repository.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/support_chat/controllers/support_chat_controller.dart';
import 'features/support_chat/support_chat_repository.dart';
import 'shared/repositories/category_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put<SessionStorage>(SessionStorage(), permanent: true);
  Get.put<DioClient>(DioClient(), permanent: true);
  Get.put<AuthRepository>(AuthRepository(), permanent: true);
  Get.put<CategoryRepository>(CategoryRepository(), permanent: true);
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true);
  Get.put<SupportChatRepository>(SupportChatRepository(), permanent: true);
  Get.put<SupportChatController>(SupportChatController(), permanent: true);

  runApp(const PripackApp());
}
