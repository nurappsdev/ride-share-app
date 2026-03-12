class DriverModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  double? avgRating;
  int? totalRating;
  String? createdAt;
  int? totalRides;

  DriverModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.avgRating,
    this.totalRating,
    this.createdAt,
    this.totalRides,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    avgRating: json["avgRating"]?.toDouble(),
    totalRating: json["totalRating"],
    createdAt: json["createdAt"],
    totalRides: json["totalRides"],
  );
}