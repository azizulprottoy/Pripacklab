import '../../core/utils/image_url.dart';

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        min: (json['min'] as num?)?.toDouble() ?? 0,
        max: (json['max'] as num?)?.toDouble() ?? 0,
      );
}

class CriteriaModel {
  final String name;
  final List<String> values;

  CriteriaModel({required this.name, required this.values});

  factory CriteriaModel.fromJson(Map<String, dynamic> json) => CriteriaModel(
        name: json['name'] ?? '',
        values: (json['values'] as List? ?? []).map((e) => e.toString()).toList(),
      );
}

class VariantModel {
  final String id;
  final Map<String, String> combination;
  final String label;
  final String price;
  final String? discount;
  final bool isActive;

  VariantModel({
    required this.id,
    required this.combination,
    required this.label,
    required this.price,
    this.discount,
    this.isActive = true,
  });

  double get priceValue => double.tryParse(price) ?? 0;

  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
        id: json['id']?.toString() ?? '',
        combination: Map<String, String>.from(
          (json['combination'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
        ),
        label: json['label'] ?? '',
        price: json['price']?.toString() ?? '0',
        discount: json['discount']?.toString(),
        isActive: json['is_active'] ?? true,
      );
}

/// One model shared by list summaries (home/category/search) and full
/// product details — summary endpoints just omit criteria/variants/etc.
class ProductModel {
  final String id;
  final String productName;
  final String productDescription;
  final String category;
  final String? subCategory;
  final List<String> mainPics;
  final double avgRating;
  final int totalRatings;
  final PriceRange? priceRange;
  final List<String> tags;
  final List<CriteriaModel> criteria;
  final List<VariantModel> variants;
  final String? deliveryTime;
  final String? sellerId;
  final String? sellerName;

  ProductModel({
    required this.id,
    required this.productName,
    this.productDescription = '',
    required this.category,
    this.subCategory,
    this.mainPics = const [],
    this.avgRating = 0,
    this.totalRatings = 0,
    this.priceRange,
    this.tags = const [],
    this.criteria = const [],
    this.variants = const [],
    this.deliveryTime,
    this.sellerId,
    this.sellerName,
  });

  List<String> get imageUrls => mainPics.map(resolveImageUrl).toList();
  String get firstImageUrl => mainPics.isNotEmpty ? resolveImageUrl(mainPics.first) : '';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      productName: json['productName'] ?? '',
      productDescription: json['productDescription'] ?? '',
      category: json['category']?.toString() ?? '',
      subCategory: json['subCategory']?.toString(),
      mainPics: (json['mainPics'] as List? ?? []).map((e) => e.toString()).toList(),
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      priceRange: json['priceRange'] != null
          ? PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>)
          : null,
      tags: (json['tags'] as List? ?? []).map((e) => e.toString()).toList(),
      criteria: (json['criteria'] as List? ?? [])
          .map((e) => CriteriaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List? ?? [])
          .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryTime: json['deliveryTime'],
      sellerId: json['sellerId']?.toString(),
      sellerName: json['sellerName'],
    );
  }
}
