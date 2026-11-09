import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../app/routes/routes_path.dart';
import '../../core/storage/session_storage.dart';
import 'auth_repository.dart';
import 'login/models/app_user.dart';

/// App-wide session state — mirrors reacttemplate's AuthProvider context.
/// Registered permanent in main() so any screen can react to login state.
class AuthController extends GetxController {
  final SessionStorage _session = Get.find<SessionStorage>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final Rxn<AppUser> user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  void restoreSession() {
    final cached = _session.user;
    if (cached != null) {
      user.value = AppUser.fromJson(cached);
    }
  }

  /// Returns null on success, or an error message to display on failure.
  Future<String?> login({
    required String emailOrPhone,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final data = await _authRepository.login(
        emailOrPhone: emailOrPhone,
        password: password,
      );

      if (data['success'] == true && data['token'] != null && data['user'] != null) {
        final userJson = data['user'] as Map<String, dynamic>;
        await _session.saveSession(token: data['token'], user: userJson);
        user.value = AppUser.fromJson(userJson);
        return null;
      }
      return data['message']?.toString() ?? 'Invalid credentials';
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map<String, dynamic>) {
        return body['message']?.toString() ?? 'Login failed';
      }
      return 'Network error. Check your connection.';
    } catch (e) {
      return 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _session.clear();
    user.value = null;
    Get.offAllNamed(RoutesPath.login);
  }
}
