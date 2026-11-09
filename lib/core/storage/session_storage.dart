import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/constants.dart';

/// Mirrors reacttemplate's AuthProvider (localStorage authToken/authUser) —
/// the backend never actually verifies the JWT server-side, so this is
/// purely a client-side session cache, not a security boundary.
class SessionStorage extends GetxService {
  final GetStorage _box = GetStorage();

  String? get token => _box.read<String>(AppConstants.authTokenKey);

  Map<String, dynamic>? get user {
    final raw = _box.read<String>(AppConstants.authUserKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  bool get isLoggedIn => token != null && user != null;

  bool get isSeller => user?['atype'] == 'seller';

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await _box.write(AppConstants.authTokenKey, token);
    await _box.write(AppConstants.authUserKey, jsonEncode(user));
  }

  Future<void> clear() async {
    await _box.remove(AppConstants.authTokenKey);
    await _box.remove(AppConstants.authUserKey);
  }
}
