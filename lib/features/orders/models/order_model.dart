import '../../../core/utils/image_url.dart';

class UnitDetail {
  final String description;
  final String? fileName;

  UnitDetail({required this.description, this.fileName});

  factory UnitDetail.fromJson(Map<String, dynamic> json) => UnitDetail(
        description: json['description'] ?? '',
        fileName: json['fileName'],
      );
}

class OrderCartItem {
  final String productId;
  final String productName;
  final String? selectedImage;
  final List<String> mainPics;
  final Map<String, String> combination;
  final double selectedPrice;
  final int units;
  final List<UnitDetail> unitDetails;
  final String? sellerId;
  final String? sellerName;

  OrderCartItem({
    required this.productId,
    required this.productName,
    this.selectedImage,
    this.mainPics = const [],
    this.combination = const {},
    required this.selectedPrice,
    this.units = 1,
    this.unitDetails = const [],
    this.sellerId,
    this.sellerName,
  });

  String get imageUrl {
    if (selectedImage != null && selectedImage!.isNotEmpty) return resolveImageUrl(selectedImage);
    if (mainPics.isNotEmpty) return resolveImageUrl(mainPics.first);
    return '';
  }

  factory OrderCartItem.fromJson(Map<String, dynamic> json) => OrderCartItem(
        productId: json['productId']?.toString() ?? '',
        productName: json['productName'] ?? '',
        selectedImage: json['selectedImage'],
        mainPics: (json['mainPics'] as List? ?? []).map((e) => e.toString()).toList(),
        combination: Map<String, String>.from(
          (json['combination'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
        ),
        selectedPrice: (json['selectedPrice'] as num?)?.toDouble() ?? 0,
        units: (json['units'] as num?)?.toInt() ?? 1,
        unitDetails: (json['unitDetails'] as List? ?? [])
            .map((e) => UnitDetail.fromJson(e as Map<String, dynamic>))
            .toList(),
        sellerId: json['sellerId']?.toString(),
        sellerName: json['sellerName']?.toString(),
      );
}

class StatusEntry {
  final String status;
  final String note;
  final DateTime? date;

  StatusEntry({required this.status, this.note = '', this.date});

  factory StatusEntry.fromJson(Map<String, dynamic> json) => StatusEntry(
        status: json['status'] ?? '',
        note: json['note'] ?? '',
        date: DateTime.tryParse(json['date']?.toString() ?? ''),
      );
}

class DeliveryInfo {
  final String area;
  final String period;
  final double charge;

  DeliveryInfo({this.area = '', this.period = '', this.charge = 0});

  factory DeliveryInfo.fromJson(Map<String, dynamic>? json) => DeliveryInfo(
        area: json?['area'] ?? '',
        period: json?['period'] ?? '',
        charge: (json?['charge'] as num?)?.toDouble() ?? 0,
      );
}

/// Mirrors the order document shape returned by GET /getorders/:customerId
/// (see reacttempletebackend orderController — same document also used by
/// reacttemplate's Profile.jsx).
class OrderModel {
  final String id;
  final String? referenceCode;
  final DateTime? orderDate;
  final String currentStatus;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? paymentNumber;
  final String? transactionId;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final String buyerAddress;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double totalPrice;
  final String? coupon;
  final DeliveryInfo delivery;
  final List<OrderCartItem> cartItems;
  final List<StatusEntry> statusHistory;

  OrderModel({
    required this.id,
    this.referenceCode,
    this.orderDate,
    required this.currentStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.paymentNumber,
    this.transactionId,
    this.buyerName = '',
    this.buyerEmail = '',
    this.buyerPhone = '',
    this.buyerAddress = '',
    this.subtotal = 0,
    this.deliveryCharge = 0,
    this.discount = 0,
    this.totalPrice = 0,
    this.coupon,
    required this.delivery,
    this.cartItems = const [],
    this.statusHistory = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['_id']?.toString() ?? '',
        referenceCode: json['referenceCode']?.toString(),
        orderDate: DateTime.tryParse(json['orderDate']?.toString() ?? ''),
        currentStatus: json['currentStatus'] ?? 'Placed',
        paymentStatus: json['paymentStatus'] ?? json['payment'],
        paymentMethod: json['paymentMethod'],
        paymentNumber: json['paymentNumber'],
        transactionId: json['transactionId'],
        buyerName: json['buyerName'] ?? '',
        buyerEmail: json['buyerEmail'] ?? '',
        buyerPhone: json['buyerPhone'] ?? '',
        buyerAddress: json['buyerAddress'] ?? '',
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0,
        discount: (json['discount'] as num?)?.toDouble() ?? 0,
        totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
        coupon: json['coupon'],
        delivery: DeliveryInfo.fromJson(json['delivery'] as Map<String, dynamic>?),
        cartItems: (json['cartItems'] as List? ?? [])
            .map((e) => OrderCartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        statusHistory: (json['statusHistory'] as List? ?? [])
            .map((e) => StatusEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
