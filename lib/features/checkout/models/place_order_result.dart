class PlaceOrderResult {
  final bool success;
  final bool exists;
  final String? orderId;

  PlaceOrderResult({required this.success, required this.exists, this.orderId});

  factory PlaceOrderResult.fromJson(Map<String, dynamic> json) => PlaceOrderResult(
        success: json['success'] == true,
        exists: json['exists'] == true,
        orderId: json['orderId']?.toString(),
      );
}
