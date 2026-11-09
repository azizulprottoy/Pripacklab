import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/theme/app_colors.dart';
import '../../../res/theme/app_text_styles.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/main_bottom_nav.dart';
import '../../auth/auth_controller.dart';
import '../../orders/models/order_model.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingIndicator();

        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              _userCard(),
              const SizedBox(height: 16),
              if (controller.orders.isEmpty)
                _emptyOrders()
              else ...[
                _orderTabs(),
                const SizedBox(height: 12),
                if (controller.activeOrder != null) _orderCard(context, controller.activeOrder!),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
      bottomSheet: Obx(() => controller.isReviewFormOpen.value ? _reviewSheet(context) : const SizedBox.shrink()),
      bottomNavigationBar: const MainBottomNav(current: MainNavTab.profile),
    );
  }

  Widget _userCard() {
    final user = Get.find<AuthController>().user.value;
    if (user == null) return const SizedBox.shrink();

    final initials = user.name.trim().isEmpty
        ? 'U'
        : user.name.trim().split(RegExp(r'\s+')).map((e) => e[0]).take(2).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.emerald,
            child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name.isEmpty ? 'Customer' : user.name, style: AppTextStyles.subheading),
                const SizedBox(height: 2),
                Text(user.email.isEmpty ? 'No email' : user.email, style: AppTextStyles.bodyMuted),
                const SizedBox(height: 2),
                Text(user.phone.isEmpty ? 'Not provided' : user.phone, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyOrders() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined, size: 56, color: AppColors.textFaint),
          const SizedBox(height: 12),
          const Text('No orders yet', style: AppTextStyles.subheading),
          const SizedBox(height: 4),
          const Text('Start shopping to see your orders here.', style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }

  Widget _orderTabs() {
    return Obx(() {
      final active = controller.activeOrder;
      return SizedBox(
        height: 56,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.orders.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            final isActive = active?.id == order.id;
            return InkWell(
              onTap: () => controller.selectOrder(order.id),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isActive ? AppColors.primary : AppColors.border, width: isActive ? 2 : 1),
                  color: isActive ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('#${order.referenceCode ?? order.id.substring(0, 6)}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? AppColors.primaryDark : AppColors.textFaint)),
                    Text(order.currentStatus, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _orderCard(BuildContext context, OrderModel order) {
    final currentIndex = controller.getStatusIndex(order);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#${order.referenceCode ?? order.id}', style: AppTextStyles.subheading),
                      if (order.orderDate != null)
                        Text(DateFormat('d MMM y').format(order.orderDate!), style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: [
                    _badge(order.currentStatus, AppColors.indigo),
                    if (order.paymentStatus != null) _badge(order.paymentStatus!, AppColors.warning),
                    OutlinedButton.icon(
                      onPressed: () => controller.generateInvoice(order),
                      icon: const Icon(Icons.receipt_long, size: 14),
                      label: const Text('Invoice', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          for (final item in order.cartItems) _cartItemTile(order, item),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: _trackingRow(order, currentIndex),
          ),
          const Divider(height: 1),
          _detailsSection(order),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _cartItemTile(OrderModel order, OrderCartItem item) {
    final canReview = order.currentStatus == 'Delivered';
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl.isEmpty
                ? Container(width: 56, height: 56, color: AppColors.surfaceMuted)
                : CachedNetworkImage(imageUrl: item.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: AppTextStyles.subheading),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    ...item.combination.entries.map((e) => _chip('${e.key}: ${e.value}')),
                    _chip('Units: ${item.units}'),
                    _chip('৳${item.selectedPrice.toStringAsFixed(0)}', color: AppColors.success),
                  ],
                ),
                if (item.unitDetails.any((u) => u.description.isNotEmpty)) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Note: ${item.unitDetails.map((u) => u.description).where((d) => d.isNotEmpty).join(', ')}',
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
                if (canReview) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.openReview(
                        orderId: order.id,
                        productId: item.productId,
                        productName: item.productName,
                      ),
                      icon: const Icon(Icons.star, size: 14),
                      label: const Text('Review', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: (color ?? AppColors.textMuted).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 11, color: color ?? AppColors.textMuted, fontWeight: FontWeight.w600)),
    );
  }

  Widget _trackingRow(OrderModel order, int currentIndex) {
    final steps = ProfileController.statusFlow;
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: i <= currentIndex ? AppColors.primary : AppColors.border,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(steps[i].icon, size: 16, color: i <= currentIndex ? Colors.white : AppColors.textFaint),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[i].label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: i <= currentIndex ? AppColors.textDark : AppColors.textFaint),
                ),
              ],
            ),
          ),
          if (i != steps.length - 1)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 2,
                color: i < currentIndex ? AppColors.primary : AppColors.border,
              ),
            ),
        ],
      ],
    );
  }

  Widget _detailsSection(OrderModel order) {
    return ExpansionTile(
      title: const Text('Order Details', style: AppTextStyles.subheading),
      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _detailBox('Buyer', [order.buyerName, order.buyerEmail, order.buyerPhone, order.buyerAddress]),
            _detailBox('Delivery', [order.delivery.area, 'Est. ${order.delivery.period}', 'Charge: ৳${order.delivery.charge.toStringAsFixed(0)}']),
            _detailBox('Payment', [
              'Method: ${order.paymentMethod ?? '-'}',
              'Number: ${order.paymentNumber ?? '-'}',
              order.transactionId ?? '-',
              order.paymentStatus ?? '-',
            ]),
            _detailBox('Summary', [
              'Subtotal: ৳${order.subtotal.toStringAsFixed(0)}',
              'Delivery: ৳${order.deliveryCharge.toStringAsFixed(0)}',
              if (order.discount > 0) 'Discount: -৳${order.discount.toStringAsFixed(0)}',
              if (order.coupon != null) 'Coupon: ${order.coupon}',
              'Total: ৳${order.totalPrice.toStringAsFixed(0)}',
            ]),
          ],
        ),
      ],
    );
  }

  Widget _detailBox(String title, List<String> lines) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.label),
          const SizedBox(height: 6),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(line, style: AppTextStyles.bodyMuted),
            ),
        ],
      ),
    );
  }

  Widget _reviewSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rate Your Experience', style: AppTextStyles.subheading),
                    Text(controller.reviewProductName, style: AppTextStyles.bodyMuted, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: controller.closeReview),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Obx(
              () => RatingBar.builder(
                initialRating: controller.rating.value.toDouble(),
                minRating: 1,
                itemCount: 5,
                itemSize: 36,
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) => controller.rating.value = value.round(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.reviewTextController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Share your experience…'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: controller.closeReview, child: const Text('Cancel')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSubmittingReview.value ? null : controller.submitReview,
                    child: controller.isSubmittingReview.value
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Submit Review'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
