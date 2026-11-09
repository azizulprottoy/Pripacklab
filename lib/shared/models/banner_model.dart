import '../../core/utils/image_url.dart';

class BannerModel {
  final String id;
  final String bannername;
  final num bannerorder;
  final String webbanner;
  final String phonebanner;

  BannerModel({
    required this.id,
    this.bannername = '',
    this.bannerorder = 0,
    this.webbanner = '',
    this.phonebanner = '',
  });

  String get webUrl => resolveImageUrl(webbanner);
  String get phoneUrl => resolveImageUrl(phonebanner);

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['_id']?.toString() ?? '',
        bannername: json['bannername'] ?? '',
        bannerorder: json['bannerorder'] is num
            ? json['bannerorder']
            : num.tryParse(json['bannerorder']?.toString() ?? '') ?? 0,
        webbanner: json['webbanner'] ?? '',
        phonebanner: json['phonebanner'] ?? '',
      );
}
