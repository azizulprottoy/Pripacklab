class CouponModel {
  final String id;
  final String couponCode;
  final String? couponName;
  final double discount;
  final String discountType; // 'fixed' | 'percent'
  final double? maxAmount;
  final double? minSpent;
  final DateTime? couponDate;
  final int? remaining;

  CouponModel({
    required this.id,
    required this.couponCode,
    this.couponName,
    required this.discount,
    required this.discountType,
    this.maxAmount,
    this.minSpent,
    this.couponDate,
    this.remaining,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['_id']?.toString() ?? '',
        couponCode: json['couponcode']?.toString() ?? '',
        couponName: json['couponname']?.toString(),
        discount: double.tryParse(json['discount']?.toString() ?? '') ?? 0,
        discountType: json['discounttype']?.toString() ?? 'fixed',
        maxAmount: double.tryParse(json['maxamount']?.toString() ?? ''),
        minSpent: double.tryParse(json['minspent']?.toString() ?? ''),
        couponDate: DateTime.tryParse(json['coupondate']?.toString() ?? ''),
        remaining: (json['remaining'] as num?)?.toInt(),
      );
}
