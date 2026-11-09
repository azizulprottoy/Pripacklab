import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  AppConstants._();

  /// Backend has no API prefix — every route is a bare path off this host.
  /// Android emulator can't reach the host machine's `localhost`, so it needs
  /// the special `10.0.2.2` alias; iOS simulator/desktop use `localhost`
  /// directly. Override here when pointing at a deployed backend.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5001';
    if (Platform.isAndroid) return 'http://10.0.2.2:5001';
    return 'http://localhost:5001';
  }

  /// The chat WebSocket is attached to the SAME http server as the REST API
  /// (see reacttempletebackend/index.js — one httpServer instance for both),
  /// so it shares host/port with [baseUrl]. reacttemplate's own config.jsx
  /// hardcodes a stale port 5000 for this — not replicating that bug here.
  static String get chatWsUrl => 'ws${baseUrl.substring(baseUrl.indexOf(':'))}';

  static const String cartStorageKey = 'cart_items';
  static const String authTokenKey = 'auth_token';
  static const String authUserKey = 'auth_user';
  static const String supportUserKey = 'support_user';
}
