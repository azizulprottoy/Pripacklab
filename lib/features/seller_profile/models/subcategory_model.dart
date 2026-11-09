class SubcategoryModel {
  final String id;
  final String catname;
  final String subcat;

  SubcategoryModel({required this.id, required this.catname, required this.subcat});

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
        id: json['_id']?.toString() ?? '',
        catname: json['catname'] ?? '',
        subcat: json['subcat'] ?? '',
      );
}
