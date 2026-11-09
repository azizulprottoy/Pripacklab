import '../../../shared/models/ad_model.dart';
import '../../../shared/models/banner_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/models/product_model.dart';

/// One category with its preview products, as returned by GET /gethome —
/// note: these product entries omit subCategory (home-only projection).
class HomeCategorySection {
  final String id;
  final String catname;
  final List<ProductModel> products;

  HomeCategorySection({required this.id, required this.catname, required this.products});

  factory HomeCategorySection.fromJson(Map<String, dynamic> json) => HomeCategorySection(
        id: json['_id']?.toString() ?? '',
        catname: json['catname'] ?? '',
        products: (json['products'] as List? ?? [])
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class HomeData {
  final List<CategoryModel> cats;
  final List<BannerModel> banners;
  final List<HomeCategorySection> categories;
  final List<AdModel> ads;

  HomeData({
    required this.cats,
    required this.banners,
    required this.categories,
    required this.ads,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        cats: (json['cats'] as List? ?? [])
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        banners: (json['banner'] as List? ?? [])
            .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        categories: (json['categories'] as List? ?? [])
            .map((e) => HomeCategorySection.fromJson(e as Map<String, dynamic>))
            .toList(),
        ads: (json['ads'] as List? ?? [])
            .map((e) => AdModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
