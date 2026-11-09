import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../features/auth/seller_register/models/geo_models.dart';

class GeoRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<List<DivisionModel>> getDivisions() async {
    final res = await _dio.get(ApiEndpoints.divisions);
    return (res.data as List)
        .map((e) => DivisionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DistrictModel>> getDistricts({String? divisionId}) async {
    final res = await _dio.get(
      ApiEndpoints.districts,
      queryParameters: divisionId != null ? {'division': divisionId} : null,
    );
    return (res.data as List)
        .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AreaModel>> getAreas({String? districtId}) async {
    final res = await _dio.get(
      ApiEndpoints.areas,
      queryParameters: districtId != null ? {'district': districtId} : null,
    );
    return (res.data as List)
        .map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
