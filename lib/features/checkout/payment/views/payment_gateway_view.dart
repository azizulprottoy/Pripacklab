import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/theme/app_colors.dart';
import '../../../../res/theme/app_text_styles.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../controllers/payment_gateway_controller.dart';

class PaymentGatewayView extends GetView<PaymentGatewayController> {
  const PaymentGatewayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Order')),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _summaryCard(),
            const SizedBox(height: 14),
            _refCodeCard(),
            const SizedBox(height: 14),
            _paymentMethodsCard(),
            const SizedBox(height: 14),
            _transactionIdCard(),
            if (controller.error.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(controller.error.value, style: const TextStyle(color: AppColors.error)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.isSubmitting.value ? null : controller.confirmPayment,
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Payment Done →'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your payment will be verified by our team within 24 hours.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _summaryCard() {
    return _card(
      child: Wrap(
        spacing: 20,
        runSpacing: 10,
        children: [
          _stat('Subtotal', controller.subtotal),
          _stat('Delivery', controller.deliveryCharge),
          if (controller.discount > 0) _stat('Discount', -controller.discount, color: AppColors.primary),
          _stat('Total', controller.totalPrice, bold: true),
        ],
      ),
    );
  }

  Widget _stat(String label, double value, {bool bold = false, Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 2),
        Text(
          '৳${value.toStringAsFixed(2)}',
          style: bold
              ? AppTextStyles.heading.copyWith(color: AppColors.primaryDark)
              : AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  Widget _refCodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('YOUR REFERENCE CODE', style: AppTextStyles.label),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: controller.refCode.split('').map((c) {
                  return Container(
                    width: 32,
                    height: 38,
                    margin: const EdgeInsets.only(right: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Text(c, style: AppTextStyles.heading.copyWith(color: AppColors.primaryDark)),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () => controller.copy(controller.refCode),
                child: const Text('Copy Code'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Use this code as reference/note when sending payment.', style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }

  Widget _paymentMethodsCard() {
    return _card(
      title: 'Select Payment Method',
      child: Obx(() {
        if (controller.paymentMethods.isEmpty) {
          return const Text('No payment methods available.', style: AppTextStyles.bodyMuted);
        }
        return Column(
          children: controller.paymentMethods.map((method) {
            final isSelected = controller.selectedMethod.value?.id == method.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => controller.selectedMethod.value = method,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(method.method, style: AppTextStyles.subheading),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(method.number, style: AppTextStyles.body),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => controller.copy(method.number),
                            child: const Text('copy', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                          ),
                        ],
                      ),
                      if (method.extraDetails != null && method.extraDetails!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(method.extraDetails!, style: AppTextStyles.bodyMuted),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _transactionIdCard() {
    return _card(
      title: 'Transaction / TrxID',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.transactionIdController,
            decoration: const InputDecoration(hintText: 'Enter your transaction ID here'),
          ),
          const SizedBox(height: 6),
          const Text('Copy the TrxID from your payment app after sending money.', style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }

  Widget _card({String? title, required Widget child}) {
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
}
