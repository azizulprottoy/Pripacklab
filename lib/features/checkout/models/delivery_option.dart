class DeliveryOption {
  final String id;
  final String area;
  final String period;
  final double charge;

  DeliveryOption({
    required this.id,
    required this.area,
    required this.period,
    required this.charge,
  });

  factory DeliveryOption.fromJson(Map<String, dynamic> json) => DeliveryOption(
        id: json['_id']?.toString() ?? '',
        area: json['area']?.toString() ?? '',
        period: json['period']?.toString() ?? '',
        charge: double.tryParse(json['charge']?.toString() ?? '') ?? 0,
      );
}
