import 'package:get/get.dart';

import '../../../../app/routes/routes_path.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/category_model.dart';
import '../../../../shared/repositories/category_repository.dart';
import '../../../../shared/repositories/geo_repository.dart';
import '../../../../shared/widgets/snack_message.dart';
import '../../auth_repository.dart';
import '../models/geo_models.dart';

class SellerRegisterController extends GetxController {
  final GeoRepository _geoRepository = Get.find<GeoRepository>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString password = ''.obs;
  final RxString address = ''.obs;

  final RxList<DivisionModel> divisions = <DivisionModel>[].obs;
  final RxList<DistrictModel> districts = <DistrictModel>[].obs;
  final RxList<AreaModel> subDistricts = <AreaModel>[].obs;

  final Rxn<DivisionModel> selectedDivision = Rxn<DivisionModel>();
  final Rxn<DistrictModel> selectedDistrict = Rxn<DistrictModel>();
  final Rxn<AreaModel> selectedSubDistrict = Rxn<AreaModel>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<String> selectedServices = <String>[].obs;

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDivisions();
    _loadCategories();
  }

  Future<void> _loadDivisions() async {
    try {
      divisions.value = await _geoRepository.getDivisions();
    } catch (_) {
      SnackMessage.showError('Failed to load divisions');
    }
  }

  Future<void> _loadCategories() async {
    try {
      categories.value = await _categoryRepository.getCategories();
    } catch (_) {
      SnackMessage.showError('Failed to load service categories');
    }
  }

  Future<void> onDivisionChanged(DivisionModel? division) async {
    selectedDivision.value = division;
    selectedDistrict.value = null;
    selectedSubDistrict.value = null;
    districts.clear();
    subDistricts.clear();
    if (division == null) return;

    try {
      districts.value = await _geoRepository.getDistricts(divisionId: division.id);
    } catch (_) {
      SnackMessage.showError('Failed to load districts');
    }
  }

  Future<void> onDistrictChanged(DistrictModel? district) async {
    selectedDistrict.value = district;
    selectedSubDistrict.value = null;
    subDistricts.clear();
    if (district == null) return;

    try {
      subDistricts.value = await _geoRepository.getAreas(districtId: district.id);
    } catch (_) {
      SnackMessage.showError('Failed to load sub-districts');
    }
  }

  void toggleService(String catname) {
    if (selectedServices.contains(catname)) {
      selectedServices.remove(catname);
    } else {
      selectedServices.add(catname);
    }
  }

  Future<void> submit() async {
    if (!isValidEmail(email.value)) {
      message.value = 'Please enter a valid email address.';
      return;
    }
    if (!isValidPhone(phone.value)) {
      message.value = 'Please enter a valid Bangladeshi phone number (e.g. 01XXXXXXXXX).';
      return;
    }
    if (selectedDivision.value == null ||
        selectedDistrict.value == null ||
        selectedSubDistrict.value == null) {
      message.value = 'Please select division, district and sub-district.';
      return;
    }
    if (selectedServices.isEmpty) {
      message.value = 'Please select at least one service.';
      return;
    }
    if (name.value.trim().isEmpty || address.value.trim().isEmpty || password.value.isEmpty) {
      message.value = 'Please fill all required fields.';
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.registerSeller({
        'name': name.value.trim(),
        'email': email.value.trim(),
        'phone': phone.value.trim(),
        'password': password.value,
        'division': selectedDivision.value!.id,
        'district': selectedDistrict.value!.id,
        'subDistrict': selectedSubDistrict.value!.id,
        'address': address.value.trim(),
        'services': selectedServices,
      });
      SnackMessage.showSuccess('Registration successful! You can now log in.');
      Get.offAllNamed(RoutesPath.login);
    } catch (e) {
      message.value = 'Registration failed. Try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
