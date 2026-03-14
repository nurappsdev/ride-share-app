class VehicleModel {
  String? carModelId;
  int? seat;
  String? licenseNo;
  int? year;
  String? carModelName;

  VehicleModel({
    this.carModelId,
    this.seat,
    this.licenseNo,
    this.year,
    this.carModelName,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      carModelId: json['carModelId'],
      seat: json['seat'],
      licenseNo: json['licenseNo'],
      year: json['year'],
      carModelName: json['carModelName'],
    );
  }
}
