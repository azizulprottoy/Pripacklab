import 'package:get/get.dart';

import '../../../shared/repositories/geo_repository.dart';
import '../../auth/auth_controller.dart';

/// Resolves the seller's division/district/sub-district ids (stored on the
/// user record) to human-readable names, same lookups as reacttemplate's
/// SellerProfile.jsx.
class SellerDashboardController extends GetxController {
  final GeoRepository _geoRepository = Get.find<GeoRepository>();
  final AuthController auth = Get.find<AuthController>();

  final RxInt tabIndex = 0.obs;
  final RxString divisionName = ''.obs;
  final RxString districtName = ''.obs;
  final RxString subDistrictName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _resolveGeo();
  }

  Future<void> _resolveGeo() async {
    final user = auth.user.value;
    if (user == null) return;

    if (user.division != null && user.division!.isNotEmpty) {
      try {
        final divisions = await _geoRepository.getDivisions();
        for (final d in divisions) {
          if (d.id == user.division) {
            divisionName.value = d.name;
            break;
          }
        }
      } catch (_) {}
    }

    if (user.division != null && user.district != null && user.district!.isNotEmpty) {
      try {
        final districts = await _geoRepository.getDistricts(divisionId: user.division);
        for (final d in districts) {
          if (d.id == user.district) {
            districtName.value = d.name;
            break;
          }
        }
      } catch (_) {}
    }

    if (user.district != null && user.subDistrict != null && user.subDistrict!.isNotEmpty) {
      try {
        final areas = await _geoRepository.getAreas(districtId: user.district);
        for (final a in areas) {
          if (a.id == user.subDistrict) {
            subDistrictName.value = a.name;
            break;
          }
        }
      } catch (_) {}
    }
  }
}
