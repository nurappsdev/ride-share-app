class RideData {
  String? id;
  String? carModelId;
  int? seat;
  String? type;
  int? passengers;
  String? dateTime;
  List<String>? luggages;
  String? luggageDetails;
  String? note;
  LocationModel? fromLocation;
  LocationModel? toLocation;
  double? distance;
  double? fare;
  double? charge;
  double? totalFare;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;
  CarModel? carModel;
  String? fromAddress;
  String? toAddress;
  OtherUser? otherUser; // ADDED THIS FIELD

  RideData({
    this.id,
    this.carModelId,
    this.seat,
    this.type,
    this.passengers,
    this.dateTime,
    this.luggages,
    this.luggageDetails,
    this.note,
    this.fromLocation,
    this.toLocation,
    this.distance,
    this.fare,
    this.charge,
    this.totalFare,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.carModel,
    this.fromAddress,
    this.toAddress,
    this.otherUser,
  });

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
    id: json["_id"],
    carModelId: json["carModelId"],
    seat: json["seat"],
    type: json["type"],
    passengers: json["passengers"],
    dateTime: json["dateTime"],
    luggages: json["luggages"] == null
        ? []
        : List<String>.from(json["luggages"]!.map((x) => x)),
    luggageDetails: json["luggageDetails"],
    note: json["note"],
    fromLocation: json["fromLocation"] == null
        ? null
        : LocationModel.fromJson(json["fromLocation"]),
    toLocation: json["toLocation"] == null
        ? null
        : LocationModel.fromJson(json["toLocation"]),
    distance: json["distance"]?.toDouble(),
    fare: json["fare"]?.toDouble(),
    charge: json["charge"]?.toDouble(),
    totalFare: json["totalFare"]?.toDouble(),
    status: json["status"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    carModel: json["carModel"] == null
        ? null
        : CarModel.fromJson(json["carModel"]),
    fromAddress: json["fromAddress"],
    toAddress: json["toAddress"],
    otherUser: json["otherUser"] == null
        ? null
        : OtherUser.fromJson(json["otherUser"]), // ADDED PARSING
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "carModelId": carModelId,
    "seat": seat,
    "type": type,
    "passengers": passengers,
    "dateTime": dateTime,
    "luggages": luggages == null
        ? []
        : List<dynamic>.from(luggages!.map((x) => x)),
    "luggageDetails": luggageDetails,
    "note": note,
    "fromLocation": fromLocation?.toJson(),
    "toLocation": toLocation?.toJson(),
    "distance": distance,
    "fare": fare,
    "charge": charge,
    "totalFare": totalFare,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "carModel": carModel?.toJson(),
    "fromAddress": fromAddress,
    "toAddress": toAddress,
    "otherUser": otherUser?.toJson(),
  };
}

class LocationModel {
  String? type;
  List<double>? coordinates;

  LocationModel({
    this.type,
    this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    type: json["type"],
    coordinates: json["coordinates"] == null
        ? []
        : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null
        ? []
        : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class CarModel {
  String? id;
  String? name;
  double? baseFare;
  double? perKm;
  double? charge;
  List<CarModelOption>? options;
  String? createdAt;
  String? updatedAt;
  int? v;

  CarModel({
    this.id,
    this.name,
    this.baseFare,
    this.perKm,
    this.charge,
    this.options,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    id: json["_id"],
    name: json["name"],
    baseFare: json["baseFare"]?.toDouble(),
    perKm: json["perKM"]?.toDouble(),
    charge: json["charge"]?.toDouble(),
    options: json["options"] == null
        ? []
        : List<CarModelOption>.from(
        json["options"]!.map((x) => CarModelOption.fromJson(x))),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "baseFare": baseFare,
    "perKM": perKm,
    "charge": charge,
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x.toJson())),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}

class CarModelOption {
  int? seat;
  double? extraPrice;

  CarModelOption({
    this.seat,
    this.extraPrice,
  });

  factory CarModelOption.fromJson(Map<String, dynamic> json) => CarModelOption(
    seat: json["seat"],
    extraPrice: json["extraPrice"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "seat": seat,
    "extraPrice": extraPrice,
  };
}


class OtherUser {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? phone;

  OtherUser({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.phone,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profileImage"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "profileImage": profileImage,
    "phone": phone,
  };
}