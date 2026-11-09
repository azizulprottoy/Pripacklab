import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../shared/widgets/snack_message.dart';
import '../../auth/auth_controller.dart';
import '../../orders/models/order_model.dart';
import '../../orders/orders_repository.dart';
import '../../reviews/review_repository.dart';

class StatusStep {
  final String key;
  final IconData icon;
  final String label;

  const StatusStep(this.key, this.icon, this.label);
}

/// Ports reacttemplate's Profile.jsx — order list with tracking timeline,
/// review submission, and PDF invoice generation.
class ProfileController extends GetxController {
  final OrdersRepository _ordersRepository = Get.find<OrdersRepository>();
  final ReviewRepository _reviewRepository = Get.find<ReviewRepository>();
  final AuthController _auth = Get.find<AuthController>();

  static const List<StatusStep> statusFlow = [
    StatusStep('Placed', Icons.check_circle, 'Placed'),
    StatusStep('Confirmed', Icons.check_circle, 'Confirmed'),
    StatusStep('On Making', Icons.access_time_filled, 'Preparing'),
    StatusStep('On Transit', Icons.local_shipping, 'In Transit'),
    StatusStep('Delivered', Icons.inventory_2, 'Delivered'),
  ];

  final RxBool isLoading = true.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxnString activeOrderId = RxnString();

  final RxBool isReviewFormOpen = false.obs;
  final RxInt rating = 0.obs;
  final TextEditingController reviewTextController = TextEditingController();
  final RxBool isSubmittingReview = false.obs;
  String? _reviewOrderId;
  String? _reviewProductId;
  String _reviewProductName = '';
  String get reviewProductName => _reviewProductName;

  OrderModel? get activeOrder {
    if (orders.isEmpty) return null;
    final id = activeOrderId.value ?? orders.first.id;
    for (final o in orders) {
      if (o.id == id) return o;
    }
    return orders.first;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final user = _auth.user.value;
    if (user == null) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      orders.value = await _ordersRepository.getCustomerOrders(user.userId);
    } catch (_) {
      orders.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void selectOrder(String id) => activeOrderId.value = id;

  int getStatusIndex(OrderModel order) {
    final keys = statusFlow.map((s) => s.key).toList();
    var max = -1;
    for (final h in order.statusHistory) {
      final i = keys.indexOf(h.status);
      if (i > max) max = i;
    }
    return max;
  }

  DateTime? getStatusDate(OrderModel order, String statusKey) {
    for (final h in order.statusHistory.reversed) {
      if (h.status == statusKey) return h.date;
    }
    return null;
  }

  void openReview({required String orderId, required String productId, required String productName}) {
    _reviewOrderId = orderId;
    _reviewProductId = productId;
    _reviewProductName = productName;
    rating.value = 0;
    reviewTextController.clear();
    isReviewFormOpen.value = true;
  }

  void closeReview() {
    isReviewFormOpen.value = false;
    _reviewOrderId = null;
    _reviewProductId = null;
    _reviewProductName = '';
    rating.value = 0;
    reviewTextController.clear();
  }

  Future<void> submitReview() async {
    final user = _auth.user.value;
    if (rating.value == 0 || reviewTextController.text.trim().isEmpty) {
      SnackMessage.showError('Please provide a rating and review text.');
      return;
    }
    if (user == null || _reviewProductId == null || _reviewOrderId == null) return;

    isSubmittingReview.value = true;
    try {
      await _reviewRepository.addReview(
        productId: _reviewProductId!,
        orderId: _reviewOrderId!,
        rating: rating.value,
        message: reviewTextController.text.trim(),
        customerId: user.userId,
        customerName: user.name,
      );
      SnackMessage.showSuccess('Review submitted successfully.');
      closeReview();
    } catch (_) {
      SnackMessage.showError('Failed to submit review.');
    } finally {
      isSubmittingReview.value = false;
    }
  }

  Future<void> generateInvoice(OrderModel order) async {
    final doc = pw.Document();
    const teal = PdfColor.fromInt(0xFF0F766E);
    const tealLight = PdfColor.fromInt(0xFFF0FDFA);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('PripackLab', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: teal)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('INVOICE', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Mirpur-10, Dhaka-1216, Bangladesh', style: const pw.TextStyle(fontSize: 8)),
                      pw.Text('support@pripacklab.com', style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 14),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                color: tealLight,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('ORDER REF', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('#${order.referenceCode ?? order.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('ORDER DATE', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(order.orderDate != null ? _formatDate(order.orderDate!) : '-'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('PAYMENT STATUS', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(order.paymentStatus ?? '-'),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('ORDER ITEMS', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: teal)),
              pw.SizedBox(height: 6),
              pw.TableHelper.fromTextArray(
                headers: ['Product', 'Units', 'Unit Price', 'Total'],
                data: [
                  for (final item in order.cartItems)
                    [
                      item.productName,
                      '${item.units}',
                      'BDT ${item.selectedPrice.toStringAsFixed(2)}',
                      'BDT ${(item.selectedPrice * item.units).toStringAsFixed(2)}',
                    ],
                ],
                headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: teal),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: const pw.TextStyle(fontSize: 9),
              ),
              pw.SizedBox(height: 16),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _summaryRow('Subtotal', order.subtotal),
                    _summaryRow('Delivery Charge', order.deliveryCharge),
                    if (order.discount > 0) _summaryRow('Discount', -order.discount),
                    pw.Divider(color: teal),
                    _summaryRow('Total', order.totalPrice, bold: true),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('PAYMENT DETAILS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: teal)),
              pw.Text('Method: ${order.paymentMethod ?? '-'}', style: const pw.TextStyle(fontSize: 9)),
              pw.Text('Txn ID: ${order.transactionId ?? '-'}', style: const pw.TextStyle(fontSize: 9)),
              pw.Text('Number: ${order.paymentNumber ?? '-'}', style: const pw.TextStyle(fontSize: 9)),
              pw.Spacer(),
              pw.Divider(color: teal),
              pw.Center(
                child: pw.Text('Thank you for shopping with us!', style: const pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  pw.Widget _summaryRow(String label, double value, {bool bold = false}) {
    final style = pw.TextStyle(fontSize: 9, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.SizedBox(width: 100, child: pw.Text(label, style: style)),
          pw.SizedBox(width: 80, child: pw.Text('BDT ${value.toStringAsFixed(2)}', style: style, textAlign: pw.TextAlign.right)),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }
}
