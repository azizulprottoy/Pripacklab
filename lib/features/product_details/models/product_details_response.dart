import '../../../shared/models/product_model.dart';

class ProcessSteps {
  final String? step1;
  final String? step2;
  final String? step3;

  ProcessSteps({this.step1, this.step2, this.step3});

  factory ProcessSteps.fromJson(Map<String, dynamic> json) => ProcessSteps(
        step1: json['step1'],
        step2: json['step2'],
        step3: json['step3'],
      );
}

class ProductDetailsResponse {
  final ProductModel product;
  final List<ProductModel> relatedProducts;
  final ProcessSteps? process;

  ProductDetailsResponse({
    required this.product,
    required this.relatedProducts,
    this.process,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    final processList = json['process'] as List?;
    return ProductDetailsResponse(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      relatedProducts: (json['relatedProducts'] as List? ?? [])
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      process: processList != null && processList.isNotEmpty
          ? ProcessSteps.fromJson(processList.first as Map<String, dynamic>)
          : null,
    );
  }
}
