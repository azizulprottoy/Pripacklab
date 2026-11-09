class CartItem {
  final String productId;
  final String productName;
  final String? selectedImage;
  final Map<String, String> combination;
  final String label;
  final double selectedPrice;
  final List<String> mainPics;
  int units;
  final int selectedQty;
  final String? sellerId;
  final String? sellerName;

  CartItem({
    required this.productId,
    required this.productName,
    this.selectedImage,
    this.combination = const {},
    required this.label,
    required this.selectedPrice,
    this.mainPics = const [],
    this.units = 1,
    this.selectedQty = 1,
    this.sellerId,
    this.sellerName,
  });

  double get lineTotal => selectedPrice * units;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'selectedImage': selectedImage,
        'combination': combination,
        'label': label,
        'selectedPrice': selectedPrice,
        'mainPics': mainPics,
        'units': units,
        'selectedQty': selectedQty,
        'sellerId': sellerId,
        'sellerName': sellerName,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId']?.toString() ?? '',
        productName: json['productName'] ?? '',
        selectedImage: json['selectedImage'],
        combination: Map<String, String>.from(
          (json['combination'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
        ),
        label: json['label'] ?? '',
        selectedPrice: (json['selectedPrice'] as num?)?.toDouble() ?? 0,
        mainPics: (json['mainPics'] as List? ?? []).map((e) => e.toString()).toList(),
        units: (json['units'] as num?)?.toInt() ?? 1,
        selectedQty: (json['selectedQty'] as num?)?.toInt() ?? 1,
        sellerId: json['sellerId']?.toString(),
        sellerName: json['sellerName'],
      );
}
