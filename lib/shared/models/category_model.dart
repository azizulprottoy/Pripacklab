import '../../core/utils/image_url.dart';

class CategoryModel {
  final String id;
  final String catname;
  final String pagecover;
  final String iconpic;
  final String homepic;

  CategoryModel({
    required this.id,
    required this.catname,
    this.pagecover = '',
    this.iconpic = '',
    this.homepic = '',
  });

  String get iconUrl => resolveImageUrl(iconpic);
  String get homeUrl => resolveImageUrl(homepic);
  String get coverUrl => resolveImageUrl(pagecover);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['_id'] ?? '',
        catname: json['catname'] ?? '',
        pagecover: json['pagecover'] ?? '',
        iconpic: json['iconpic'] ?? '',
        homepic: json['homepic'] ?? '',
      );
}
