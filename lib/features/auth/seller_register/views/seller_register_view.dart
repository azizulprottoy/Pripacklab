import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/theme/app_colors.dart';
import '../../../../res/theme/app_text_styles.dart';
import '../../../../shared/widgets/multi_select_field.dart';
import '../controllers/seller_register_controller.dart';
import '../models/geo_models.dart';

class SellerRegisterView extends GetView<SellerRegisterController> {
  const SellerRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become a Seller')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _label('Name'),
              TextField(
                onChanged: (v) => controller.name.value = v,
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),
              const SizedBox(height: 14),

              _label('Email'),
              TextField(
                onChanged: (v) => controller.email.value = v,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 14),

              _label('Phone'),
              TextField(
                onChanged: (v) => controller.phone.value = v,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'e.g. 01XXXXXXXXX'),
              ),
              const SizedBox(height: 14),

              _label('Password'),
              TextField(
                onChanged: (v) => controller.password.value = v,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Enter a password'),
              ),
              const SizedBox(height: 14),

              _label('Division'),
              Obx(
                () => DropdownButtonFormField<DivisionModel>(
                  initialValue: controller.selectedDivision.value,
                  hint: const Text('Select division'),
                  items: controller.divisions
                      .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                      .toList(),
                  onChanged: controller.onDivisionChanged,
                ),
              ),
              const SizedBox(height: 14),

              _label('District'),
              Obx(
                () => DropdownButtonFormField<DistrictModel>(
                  initialValue: controller.selectedDistrict.value,
                  hint: const Text('Select district'),
                  items: controller.districts
                      .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                      .toList(),
                  onChanged: controller.selectedDivision.value == null
                      ? null
                      : controller.onDistrictChanged,
                ),
              ),
              const SizedBox(height: 14),

              _label('Sub-district'),
              Obx(
                () => DropdownButtonFormField<AreaModel>(
                  initialValue: controller.selectedSubDistrict.value,
                  hint: const Text('Select sub-district'),
                  items: controller.subDistricts
                      .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                      .toList(),
                  onChanged: controller.selectedDistrict.value == null
                      ? null
                      : (v) => controller.selectedSubDistrict.value = v,
                ),
              ),
              const SizedBox(height: 14),

              _label('Services'),
              Obx(
                () => MultiSelectField(
                  hint: 'Select services',
                  options: controller.categories.map((c) => c.catname).toList(),
                  selected: controller.selectedServices,
                  onToggle: controller.toggleService,
                ),
              ),
              const SizedBox(height: 14),

              _label('Address'),
              TextField(
                onChanged: (v) => controller.address.value = v,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Enter your full address'),
              ),

              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.submit,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Register'),
                ),
              ),

              Obx(
                () => controller.message.value.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          controller.message.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error, fontSize: 13),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTextStyles.label),
      );
}
