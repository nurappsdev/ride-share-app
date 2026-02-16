class CarTypeModel {
  String? id;
  String? name;
  List<int>? seats;

  CarTypeModel({this.id, this.name, this.seats});

  // From JSON
  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      seats: json['seats'] != null
          ? List<int>.from(json['seats'])
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'seats': seats,
    };
  }
}
