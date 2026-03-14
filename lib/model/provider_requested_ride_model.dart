class ProviderRequestedRideModel {
  final String? jobId;
  final String? trId;
  final String? type;
  final int? passengers;
  final List<String>? luggages;
  final String? userId;
  final String? userProfile;
  final String? userName;
  final String? userPhone;
  final String? userEmail;
  final double? fare;
  final double? avgRating;
  final int? totalRating;
  final double? distance;
  final String? fromAddress;
  final String? toAddress;
  final String? dateTime;
  final String? status;

  ProviderRequestedRideModel({
    this.jobId,
    this.trId,
    this.type,
    this.passengers,
    this.luggages,
    this.userId,
    this.userProfile,
    this.userName,
    this.userPhone,
    this.userEmail,
    this.fare,
    this.avgRating,
    this.totalRating,
    this.distance,
    this.fromAddress,
    this.toAddress,
    this.dateTime,
    this.status,
  });

  factory ProviderRequestedRideModel.fromJson(Map<String, dynamic> json) {
    return ProviderRequestedRideModel(
      jobId: json['jobId'],
      trId: json['trId'],
      type: json['type'],
      passengers: json['passengers'],
      luggages: json['luggages'] != null ? List<String>.from(json['luggages']) : [],
      userId: json['userId'],
      userProfile: json['userProfile'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      userEmail: json['userEmail'],
      fare: json['fare']?.toDouble(),
      avgRating: json['avgRating']?.toDouble(),
      totalRating: json['totalRating'],
      distance: json['distance']?.toDouble(),
      fromAddress: json['fromAddress'],
      toAddress: json['toAddress'],
      dateTime: json['dateTime'],
      status: json['status'],
    );
  }
}