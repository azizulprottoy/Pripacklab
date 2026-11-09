import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/image_url.dart';
import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../controllers/checkout_controller.dart';
import '../models/delivery_option.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('No items in cart.', style: AppTextStyles.bodyMuted)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _card(
            title: 'Buyer Information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field('Name', controller.buyerNameController),
                const SizedBox(height: 12),
                _field('Email', controller.buyerEmailController),
                const SizedBox(height: 12),
                _field('Phone Number', controller.buyerPhoneController),
                if (!controller.isLoggedIn) ...[
                  const SizedBox(height: 12),
                  _field('Password', controller.passwordController, obscure: true),
                  const SizedBox(height: 12),
                  _field('Retype Password', controller.rePasswordController, obscure: true),
                ],
                const SizedBox(height: 12),
                _field('Address', controller.buyerAddressController, maxLines: 3),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _card(
            title: 'Unit Details',
            child: Column(
              children: [
                for (var pi = 0; pi < controller.cartItems.length; pi++) _unitGroup(pi),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _card(
            title: 'Delivery Option',
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingIndicator();
              if (controller.deliveryOptions.isEmpty) {
                return const Text('No delivery options available.', style: AppTextStyles.bodyMuted);
              }
              return Column(
                children: controller.deliveryOptions.map((opt) {
                  final isSelected = controller.selectedDelivery.value?.id == opt.id;
                  return _deliveryTile(opt, isSelected);
                }).toList(),
              );
            }),
          ),
          const SizedBox(height: 14),
          _card(title: 'Coupon Code', child: _couponSection()),
          const SizedBox(height: 14),
          _summaryCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _unitGroup(int pi) {
    final item = controller.cartItems[pi];
    final image = resolveImageUrl(item.selectedImage ?? (item.mainPics.isNotEmpty ? item.mainPics.first : null));
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image.isEmpty
                    ? Container(width: 44, height: 44, color: AppColors.border)
                    : CachedNetworkImage(imageUrl: image, width: 44, height: 44, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: AppTextStyles.subheading),
                    Text('${item.units} unit${item.units > 1 ? 's' : ''}', style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var ui = 0; ui < controller.unitEntries[pi].length; ui++) _unitFields(pi, ui),
        ],
      ),
    );
  }

  Widget _unitFields(int pi, int ui) {
    final entry = controller.unitEntries[pi][ui];
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Unit ${ui + 1}', style: AppTextStyles.label),
          const SizedBox(height: 8),
          _field('Description *', entry.descriptionController, maxLines: 3),
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => controller.pickUnitFile(pi, ui),
                icon: const Icon(Icons.attach_file, size: 16),
                label: const Text('Attach file'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() {
                  final file = entry.file.value;
                  if (file == null) return const SizedBox.shrink();
                  return Text(file.name, style: AppTextStyles.bodyMuted, overflow: TextOverflow.ellipsis);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryTile(DeliveryOption opt, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => controller.selectedDelivery.value = opt,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(opt.area, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                  Text(opt.period, style: AppTextStyles.bodyMuted),
                ],
              ),
              Text('৳${opt.charge.toStringAsFixed(2)}', style: AppTextStyles.price),
            ],
          ),
        ),
      ),
    );
  }

  Widget _couponSection() {
    return Obx(() {
      final applied = controller.appliedCoupon.value;
      if (applied != null) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(applied.couponCode, style: AppTextStyles.subheading.copyWith(color: AppColors.primaryDark)),
                  Text(
                    applied.discountType == 'fixed' ? '৳${applied.discount} off' : '${applied.discount}% off',
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
              ),
              TextButton(onPressed: controller.removeCoupon, child: const Text('Remove')),
            ],
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.couponInputController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(hintText: 'Enter coupon code'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: controller.applyCoupon, child: const Text('Apply')),
            ],
          ),
          if (controller.couponError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(controller.couponError.value, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ),
        ],
      );
    });
  }

  Widget _summaryCard() {
    return _card(
      title: null,
      child: Obx(() {
        final discount = controller.discountAmount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _summaryRow('Subtotal', controller.subtotal),
            _summaryRow('Delivery', controller.deliveryCharge, faint: controller.selectedDelivery.value == null),
            if (discount > 0) _summaryRow('Discount', -discount, color: AppColors.primary),
            const Divider(height: 20),
            _summaryRow('Total', controller.totalPrice, bold: true),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: controller.isSubmitting.value ? null : () => controller.submitOrder(payNow: false),
              child: const Text('Cash on Delivery'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: controller.isSubmitting.value ? null : () => controller.submitOrder(payNow: true),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Pay Now'),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false, bool faint = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? AppTextStyles.subheading : AppTextStyles.bodyMuted),
          Text(
            faint ? 'Select option' : '৳${value.toStringAsFixed(2)}',
            style: bold
                ? AppTextStyles.heading.copyWith(fontSize: 18, color: AppColors.primaryDark)
                : AppTextStyles.body.copyWith(color: color ?? (faint ? AppColors.textFaint : AppColors.textDark)),
          ),
        ],
      ),
    );
  }

  Widget _card({required String? title, required Widget child}) {
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
          if (title != null) ...[
            Text(title, style: AppTextStyles.subheading),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {bool obscure = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          decoration: const InputDecoration(isDense: true),
        ),
      ],
    );
  }
}
