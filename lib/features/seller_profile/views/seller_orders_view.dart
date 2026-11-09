import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../orders/models/order_model.dart';
import '../controllers/seller_orders_controller.dart';

class SellerOrdersView extends GetView<SellerOrdersController> {
  const SellerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const LoadingIndicator();

      if (controller.orders.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          child: ListView(
            children: const [
              SizedBox(height: 80),
              Icon(Icons.receipt_long_outlined, size: 56, color: AppColors.textFaint),
              SizedBox(height: 12),
              Center(child: Text('No orders found.', style: AppTextStyles.bodyMuted)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchOrders,
        child: ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: controller.orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _orderCard(controller.orders[index]),
        ),
      );
    });
  }

  Widget _orderCard(OrderModel order) {
    final items = controller.sellerItems(order);
    final total = controller.sellerTotal(order);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${order.referenceCode ?? order.id}', style: AppTextStyles.subheading),
                    if (order.orderDate != null)
                      Text(DateFormat('d MMM y, HH:mm').format(order.orderDate!), style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CUSTOMER', style: AppTextStyles.label),
                const SizedBox(height: 4),
                Text(order.buyerName, style: AppTextStyles.body),
                Text(order.buyerPhone, style: AppTextStyles.bodyMuted),
                Text(order.buyerEmail, style: AppTextStyles.bodyMuted),
                Text(order.buyerAddress, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('YOUR ITEMS', style: AppTextStyles.label),
          const SizedBox(height: 6),
          if (items.isEmpty)
            const Text('No items found for this seller.', style: AppTextStyles.bodyMuted)
          else
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(item.productName, style: AppTextStyles.body)),
                    Text('x${item.units}', style: AppTextStyles.bodyMuted),
                    const SizedBox(width: 8),
                    Text('৳${item.selectedPrice.toStringAsFixed(0)}', style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Your Total: ৳${total.toStringAsFixed(2)}', style: AppTextStyles.price),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: SellerOrdersController.statusOptions.contains(order.currentStatus)
                      ? order.currentStatus
                      : SellerOrdersController.statusOptions.first,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, labelText: 'Status'),
                  items: SellerOrdersController.statusOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.updateStatus(order.id, value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: SellerOrdersController.paymentOptions.contains(order.paymentStatus)
                      ? order.paymentStatus
                      : SellerOrdersController.paymentOptions.first,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, labelText: 'Payment'),
                  items: SellerOrdersController.paymentOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.updatePaymentStatus(order.id, value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
