class ReviewModel {
  final String id;
  final String productId;
  final int rating;
  final String customerName;
  final String message;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.rating,
    this.customerName = '',
    this.message = '',
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['_id']?.toString() ?? '',
        productId: json['productId']?.toString() ?? '',
        rating: (json['rating'] as num?)?.toInt() ?? 0,
        customerName: json['customerName'] ?? '',
        message: json['message'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      );
}
