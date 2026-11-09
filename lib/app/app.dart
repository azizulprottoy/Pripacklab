import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/support_chat/widgets/support_chat_overlay.dart';
import '../res/theme/app_theme.dart';
import 'routes/routes.dart';
import 'routes/routes_path.dart';

class PripackApp extends StatelessWidget {
  const PripackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PripackLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RoutesPath.splash,
      getPages: AppPages.pages,
      builder: (context, child) => Stack(
        children: [
          ?child,
          const SupportChatOverlay(),
        ],
      ),
    );
  }
}
