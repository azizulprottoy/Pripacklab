import 'package:get/get.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../features/home/models/home_data.dart';

class HomeRepository extends GetxService {
  final DioClient _dio = Get.find<DioClient>();

  Future<HomeData> getHome() async {
    final res = await _dio.get(ApiEndpoints.getHome);
    return HomeData.fromJson(res.data as Map<String, dynamic>);
  }
}
