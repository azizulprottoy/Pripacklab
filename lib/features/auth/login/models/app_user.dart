/// Shape returned by POST /customerlogin — same object for a regular
/// customer or a seller (sellers get atype forced to 'seller' server-side).
class AppUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? atype;
  final String? division;
  final String? district;
  final String? subDistrict;
  final List<String> services;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.atype,
    this.division,
    this.district,
    this.subDistrict,
    this.services = const [],
  });

  bool get isSeller => atype == 'seller';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['userId']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      atype: json['atype'],
      division: json['division']?.toString(),
      district: json['district']?.toString(),
      subDistrict: json['subDistrict']?.toString(),
      services: (json['services'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'atype': atype,
        'division': division,
        'district': district,
        'subDistrict': subDistrict,
        'services': services,
      };
}
