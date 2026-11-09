import 'package:get/get.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/ad_model.dart';
import '../../../shared/models/banner_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/repositories/home_repository.dart';
import '../models/home_data.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final DioClient _dio = Get.find<DioClient>();

  final RxBool isLoading = true.obs;
  final RxList<CategoryModel> cats = <CategoryModel>[].obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxList<HomeCategorySection> categories = <HomeCategorySection>[].obs;
  final RxList<AdModel> ads = <AdModel>[].obs;
  final RxBool popupDismissed = false.obs;

  AdModel? get popupAd {
    final matches = ads.where((a) => a.location == 'Popup' && a.isActive);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  void onInit() {
    super.onInit();
    _bumpVisitorCount();
    fetchHome();
  }

  void _bumpVisitorCount() {
    // POST /vcount never sends a response body on success — fire-and-forget.
    _dio.post(ApiEndpoints.vcount, data: {'increment': 1}).timeout(const Duration(seconds: 3)).ignore();
  }

  Future<void> fetchHome() async {
    isLoading.value = true;
    try {
      final HomeData data = await _homeRepository.getHome();
      cats.value = data.cats;
      banners.value = data.banners;
      categories.value = data.categories;
      ads.value = data.ads;
    } finally {
      isLoading.value = false;
    }
  }

  void dismissPopup() => popupDismissed.value = true;
}
