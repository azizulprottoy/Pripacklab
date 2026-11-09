import '../../core/utils/image_url.dart';

class CategoryModel {
  final String id;
  final String catname;
  final String pagecover;
  final String homepic;

  CategoryModel({
    required this.id,
    required this.catname,
    this.pagecover = '',
    this.homepic = '',
  });

  /// Backend's /getcat never sends `iconpic` — mirror reacttemplate's
  /// `homepic || pagecover` fallback for the home category grid icon.
  String get iconUrl => resolveImageUrl(homepic.isNotEmpty ? homepic : pagecover);
  String get coverUrl => resolveImageUrl(pagecover);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['_id'] ?? '',
        catname: json['catname'] ?? '',
        pagecover: json['pagecover'] ?? '',
        homepic: json['homepic'] ?? '',
      );
}
