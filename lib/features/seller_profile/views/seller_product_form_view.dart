import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/image_url.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../controllers/seller_product_form_controller.dart';

class SellerProductFormView extends GetView<SellerProductFormController> {
  const SellerProductFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.isEditing ? 'Edit Product' : 'Add Product')),
      body: Obx(() {
        if (controller.isLoadingCategories.value) return const LoadingIndicator();

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _card(
              title: 'Basic Info',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
                      hint: const Text('Select category'),
                      items: controller.categories
                          .map((c) => DropdownMenuItem(value: c.catname, child: Text(c.catname)))
                          .toList(),
                      onChanged: controller.onCategoryChanged,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Subcategory', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.selectedSubCategory.value.isEmpty ? null : controller.selectedSubCategory.value,
                      hint: const Text('Select subcategory'),
                      items: controller.filteredSubcategories
                          .map((s) => DropdownMenuItem(value: s.subcat, child: Text(s.subcat)))
                          .toList(),
                      onChanged: controller.selectedCategory.value.isEmpty ? null : controller.onSubCategoryChanged,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _field('Product Name', controller.nameController),
                  const SizedBox(height: 12),
                  _field('Delivery Time (e.g. 3-5 days)', controller.deliveryTimeController),
                  const SizedBox(height: 12),
                  _field('Description', controller.descriptionController, maxLines: 4),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _card(title: 'Tags', child: _tagsSection()),
            const SizedBox(height: 14),
            _card(title: 'Images', child: _imagesSection()),
            const SizedBox(height: 14),
            _card(title: 'Criteria', child: _criteriaSection()),
            const SizedBox(height: 14),
            _card(title: 'Variants', child: _variantsSection()),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isSubmitting.value ? null : controller.submit,
                child: controller.isSubmitting.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(controller.isEditing ? 'Update Product' : 'Add Product'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _tagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.tagInputController,
                decoration: const InputDecoration(hintText: 'Add tag', isDense: true),
                onSubmitted: (_) => controller.addTag(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: controller.addTag, child: const Text('Add')),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () => controller.removeTag(tag),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _imagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: controller.pickImages,
          icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
          label: const Text('Pick Images'),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < controller.existingPics.length; i++)
                _imageThumb(
                  networkUrl: resolveImageUrl(controller.existingPics[i]),
                  onRemove: () => controller.removeExistingImage(i),
                ),
              for (var i = 0; i < controller.pickedImages.length; i++)
                _imageThumb(
                  filePath: controller.pickedImages[i].path,
                  onRemove: () => controller.removeNewImage(i),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageThumb({String? networkUrl, String? filePath, required VoidCallback onRemove}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: filePath != null
              ? Image.file(File(filePath), width: 72, height: 72, fit: BoxFit.cover)
              : Image.network(
                  networkUrl!,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(width: 72, height: 72, color: AppColors.surfaceMuted),
                ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: InkWell(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 11,
              backgroundColor: AppColors.error,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _criteriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AddCriteriaRow(controller: controller),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: controller.criteria.map((c) {
              final valueController = controller.valueInputControllers[c.name]!;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(c.name, style: AppTextStyles.subheading)),
                        TextButton(onPressed: () => controller.removeCriteria(c.name), child: const Text('Remove')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: valueController,
                            decoration: InputDecoration(hintText: 'Add ${c.name} value', isDense: true),
                            onSubmitted: (_) => controller.addCriteriaValue(c.name),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: () => controller.addCriteriaValue(c.name), child: const Text('Add')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: c.values
                            .map((v) => Chip(
                                  label: Text(v, style: const TextStyle(fontSize: 12)),
                                  onDeleted: () => controller.removeCriteriaValue(c.name, v),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(onPressed: controller.generateVariants, child: const Text('Generate Variants')),
        ),
      ],
    );
  }

  Widget _variantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: controller.addManualVariant,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Manual Variant'),
          ),
        ),
        Obx(() {
          if (controller.variants.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text('No variants added.', style: AppTextStyles.bodyMuted)),
            );
          }
          return Column(
            children: controller.variants.map((v) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('Label', v.labelController),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _field('Price', v.priceController, keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        Expanded(child: _field('Discount %', v.discountController, keyboardType: TextInputType.number)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(value: v.isActive.value, onChanged: (val) => v.isActive.value = val ?? true),
                              const Text('Active'),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => controller.removeVariant(v.id),
                          child: const Text('Remove', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: const InputDecoration(isDense: true),
        ),
      ],
    );
  }
}

class _AddCriteriaRow extends StatefulWidget {
  final SellerProductFormController controller;

  const _AddCriteriaRow({required this.controller});

  @override
  State<_AddCriteriaRow> createState() => _AddCriteriaRowState();
}

class _AddCriteriaRowState extends State<_AddCriteriaRow> {
  String? _selected;
  final TextEditingController _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final presets = widget.controller.availableCriteriaPresets;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selected,
            hint: const Text('Select criteria'),
            items: [
              ...presets.map((p) => DropdownMenuItem(value: p, child: Text(p))),
              const DropdownMenuItem(value: 'Custom', child: Text('Custom')),
            ],
            onChanged: (value) => setState(() => _selected = value),
          ),
          if (_selected == 'Custom') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customController,
              decoration: const InputDecoration(hintText: 'Custom criteria name', isDense: true),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final name = _selected == 'Custom' ? _customController.text : (_selected ?? '');
                widget.controller.addCriteria(name);
                setState(() {
                  _selected = null;
                  _customController.clear();
                });
              },
              child: const Text('Add Criteria'),
            ),
          ),
        ],
      );
    });
  }
}
