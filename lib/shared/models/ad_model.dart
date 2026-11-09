class AdModel {
  final String id;
  final String imglink;
  final String bannername;
  final String rdlink;
  final String location;
  final DateTime? startdate;
  final DateTime? tilldate;
  final num bannerorder;

  AdModel({
    required this.id,
    this.imglink = '',
    this.bannername = '',
    this.rdlink = '',
    this.location = '',
    this.startdate,
    this.tilldate,
    this.bannerorder = 0,
  });

  bool get isActive {
    final now = DateTime.now();
    if (startdate == null || tilldate == null) return true;
    return now.isAfter(startdate!) && now.isBefore(tilldate!);
  }

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
        id: json['_id']?.toString() ?? '',
        imglink: json['imglink'] ?? '',
        bannername: json['bannername'] ?? '',
        rdlink: json['rdlink'] ?? '',
        location: json['location'] ?? '',
        startdate: DateTime.tryParse(json['startdate']?.toString() ?? ''),
        tilldate: DateTime.tryParse(json['tilldate']?.toString() ?? ''),
        bannerorder: json['bannerorder'] is num
            ? json['bannerorder']
            : num.tryParse(json['bannerorder']?.toString() ?? '') ?? 0,
      );
}
