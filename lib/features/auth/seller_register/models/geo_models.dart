class DivisionModel {
  final String id;
  final String name;

  DivisionModel({required this.id, required this.name});

  factory DivisionModel.fromJson(Map<String, dynamic> json) => DivisionModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
      );
}

class DistrictModel {
  final String id;
  final String name;
  final String divisionId;

  DistrictModel({required this.id, required this.name, required this.divisionId});

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        divisionId: json['division']?.toString() ?? '',
      );
}

class AreaModel {
  final String id;
  final String name;
  final String districtId;

  AreaModel({required this.id, required this.name, required this.districtId});

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        districtId: json['district']?.toString() ?? '',
      );
}
