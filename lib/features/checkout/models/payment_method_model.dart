class PaymentMethodModel {
  final String id;
  final String method;
  final String number;
  final String? extraDetails;

  PaymentMethodModel({
    required this.id,
    required this.method,
    required this.number,
    this.extraDetails,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
        id: json['_id']?.toString() ?? '',
        method: json['method']?.toString() ?? '',
        number: json['number']?.toString() ?? '',
        extraDetails: json['extradetails']?.toString(),
      );
}
