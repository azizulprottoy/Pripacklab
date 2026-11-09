import 'dart:convert';

import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../../shared/models/category_model.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/snack_message.dart';
import '../../auth/auth_controller.dart';
import '../models/subcategory_model.dart';
import '../seller_repository.dart';

const kPresetCriteria = ['Size', 'Cut', 'Color', 'Material', 'Quantity', 'Weight'];

class EditableCriteria {
  final String name;
  final RxList<String> values;

  EditableCriteria({required this.name, List<String>? values}) : values = RxList<String>(values ?? []);
}

class EditableVariant {
  final String id;
  final Map<String, String> combination;
  final TextEditingController labelController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final RxBool isActive;

  EditableVariant({
    required this.id,
    required this.combination,
    String label = '',
    String price = '',
    String discount = '',
    bool isActive = true,
  })  : labelController = TextEditingController(text: label),
        priceController = TextEditingController(text: price),
        discountController = TextEditingController(text: discount),
        isActive = isActive.obs;

  void dispose() {
    labelController.dispose();
    priceController.dispose();
    discountController.dispose();
  }
}

/// Ports reacttemplate's SellerProductCrud.jsx add/edit form — category cascade,
/// tags, criteria+value builder → generated variant matrix, and image picking.
class SellerProductFormController extends GetxController {
  final SellerRepository _repository = Get.find<SellerRepository>();
  final AuthController _auth = Get.find<AuthController>();

  ProductModel? _editingProduct;
  bool get isEditing => _editingProduct != null;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<SubcategoryModel> _allSubcategories = <SubcategoryModel>[].obs;
  final RxBool isLoadingCategories = true.obs;
  final RxBool isSubmitting = false.obs;

  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController tagInputController = TextEditingController();
  final RxList<String> tags = <String>[].obs;

  final RxList<EditableCriteria> criteria = <EditableCriteria>[].obs;
  final Map<String, TextEditingController> valueInputControllers = {};

  final RxList<EditableVariant> variants = <EditableVariant>[].obs;

  final RxList<XFile> pickedImages = <XFile>[].obs;
  final RxList<String> existingPics = <String>[].obs;

  List<SubcategoryModel> get filteredSubcategories => _allSubcategories
      .where((s) => s.catname.toLowerCase() == selectedCategory.value.toLowerCase())
      .toList();

  List<String> get availableCriteriaPresets =>
      kPresetCriteria.where((p) => !criteria.any((c) => c.name == p)).toList();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is ProductModel) _editingProduct = arg;
    _loadCategories();
    if (_editingProduct != null) _prefill(_editingProduct!);
  }

  void _prefill(ProductModel p) {
    selectedCategory.value = p.category;
    selectedSubCategory.value = p.subCategory ?? '';
    nameController.text = p.productName;
    deliveryTimeController.text = p.deliveryTime ?? '';
    descriptionController.text = p.productDescription;
    tags.value = List<String>.from(p.tags);
    criteria.value = p.criteria.map((c) => EditableCriteria(name: c.name, values: List<String>.from(c.values))).toList();
    for (final c in criteria) {
      valueInputControllers[c.name] = TextEditingController();
    }
    variants.value = p.variants
        .map((v) => EditableVariant(
              id: v.id.isEmpty ? 'var_${DateTime.now().microsecondsSinceEpoch}_${p.variants.indexOf(v)}' : v.id,
              combination: Map<String, String>.from(v.combination),
              label: v.label,
              price: v.price,
              discount: v.discount ?? '',
              isActive: v.isActive,
            ))
        .toList();
    existingPics.value = List<String>.from(p.mainPics);
  }

  Future<void> _loadCategories() async {
    isLoadingCategories.value = true;
    try {
      final result = await _repository.getCategoriesAndSubcategories();
      categories.value = result.categories;
      _allSubcategories.value = result.subcategories;
    } catch (_) {
      SnackMessage.showError('Failed to load categories.');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void onCategoryChanged(String? value) {
    selectedCategory.value = value ?? '';
    selectedSubCategory.value = '';
  }

  void onSubCategoryChanged(String? value) => selectedSubCategory.value = value ?? '';

  void addTag() {
    final tag = tagInputController.text.trim();
    if (tag.isEmpty || tags.contains(tag)) return;
    tags.add(tag);
    tagInputController.clear();
  }

  void removeTag(String tag) => tags.remove(tag);

  void addCriteria(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return;
    if (criteria.any((c) => c.name.toLowerCase() == clean.toLowerCase())) return;
    criteria.add(EditableCriteria(name: clean));
    valueInputControllers[clean] = TextEditingController();
    variants.clear();
  }

  void removeCriteria(String name) {
    criteria.removeWhere((c) => c.name == name);
    valueInputControllers.remove(name)?.dispose();
    variants.clear();
  }

  EditableCriteria? _findCriteria(String name) {
    for (final c in criteria) {
      if (c.name == name) return c;
    }
    return null;
  }

  void addCriteriaValue(String criteriaName) {
    final controller = valueInputControllers[criteriaName];
    final value = controller?.text.trim() ?? '';
    if (value.isEmpty) return;
    final target = _findCriteria(criteriaName);
    if (target != null && !target.values.contains(value)) {
      target.values.add(value);
    }
    controller?.clear();
    variants.clear();
  }

  void removeCriteriaValue(String criteriaName, String value) {
    _findCriteria(criteriaName)?.values.remove(value);
    variants.clear();
  }

  void generateVariants() {
    final active = criteria.where((c) => c.values.isNotEmpty).toList();
    if (active.isEmpty) {
      SnackMessage.showWarning('Add criteria values first.');
      return;
    }

    var combinations = <Map<String, String>>[{}];
    for (final c in active) {
      combinations = [
        for (final combo in combinations)
          for (final value in c.values) {...combo, c.name: value},
      ];
    }

    for (final v in variants) {
      v.dispose();
    }
    variants.value = [
      for (var i = 0; i < combinations.length; i++)
        EditableVariant(
          id: 'var_${DateTime.now().microsecondsSinceEpoch}_$i',
          combination: combinations[i],
          label: combinations[i].values.join(' / '),
        ),
    ];
  }

  void addManualVariant() {
    variants.add(EditableVariant(
      id: 'var_${DateTime.now().microsecondsSinceEpoch}',
      combination: const {},
      label: 'Default',
    ));
  }

  void removeVariant(String id) {
    for (final v in variants) {
      if (v.id == id) {
        v.dispose();
        break;
      }
    }
    variants.removeWhere((v) => v.id == id);
  }

  Future<void> pickImages() async {
    final files = await ImagePicker().pickMultiImage();
    if (files.isNotEmpty) pickedImages.addAll(files);
  }

  void removeNewImage(int index) => pickedImages.removeAt(index);
  void removeExistingImage(int index) => existingPics.removeAt(index);

  Future<void> submit() async {
    final user = _auth.user.value;
    if (selectedCategory.value.isEmpty || selectedSubCategory.value.isEmpty || nameController.text.trim().isEmpty) {
      SnackMessage.showError('Please fill category, subcategory and product name.');
      return;
    }
    if (user == null) {
      SnackMessage.showError('Seller data not found. Please login again.');
      return;
    }

    isSubmitting.value = true;
    try {
      final criteriaJson = criteria.map((c) => {'name': c.name, 'values': c.values.toList()}).toList();
      final variantsJson = variants
          .map((v) => {
                'id': v.id,
                'combination': v.combination,
                'label': v.labelController.text.trim(),
                'price': v.priceController.text.trim(),
                'discount': v.discountController.text.trim(),
                'is_active': v.isActive.value,
              })
          .toList();

      final fields = <String, dynamic>{
        'category': selectedCategory.value,
        'subCategory': selectedSubCategory.value,
        'productName': nameController.text.trim(),
        'productDescription': descriptionController.text.trim(),
        'productSupplier': user.name,
        'deliveryTime': deliveryTimeController.text.trim(),
        'sellerId': user.userId,
        'sellerName': user.name,
        'sellerPhone': user.phone,
        'tags': jsonEncode(tags.toList()),
        'criteria': jsonEncode(criteriaJson),
        'variants': jsonEncode(variantsJson),
      };
      if (isEditing) {
        fields['existingPics'] = jsonEncode(existingPics.toList());
      }

      final formData = FormData.fromMap(fields);
      for (final file in pickedImages) {
        formData.files.add(MapEntry('mainPics', await MultipartFile.fromFile(file.path, filename: file.name)));
      }

      if (isEditing) {
        await _repository.editProduct(_editingProduct!.id, formData);
      } else {
        await _repository.addProduct(formData);
      }
      // Pop before showing the snackbar — GetX's snackbar overlay can
      // otherwise swallow the very next Get.back(), leaving this form on
      // screen even though the save already succeeded.
      Get.back(result: true);
      SnackMessage.showSuccess(isEditing ? 'Product updated successfully.' : 'Product added successfully.');
    } catch (_) {
      SnackMessage.showError('Failed to save product.');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    deliveryTimeController.dispose();
    descriptionController.dispose();
    tagInputController.dispose();
    for (final c in valueInputControllers.values) {
      c.dispose();
    }
    for (final v in variants) {
      v.dispose();
    }
    super.onClose();
  }
}
