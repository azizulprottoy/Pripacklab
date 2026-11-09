import 'category_model.dart';
import 'product_model.dart';

/// Shared response shape for GET /categorydetails/:id and
/// GET /relatedproducts/:catname.
class CategoryProductsResult {
  final CategoryModel category;
  final List<ProductModel> products;

  CategoryProductsResult({required this.category, required this.products});

  factory CategoryProductsResult.fromJson(Map<String, dynamic> json) => CategoryProductsResult(
        category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
        products: (json['products'] as List? ?? [])
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
