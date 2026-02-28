class PassengerOngoingRidesModel {
  final String? jobId;
  final String? userName;
  final int? seat;
  final String? fromAddress;
  final String? toAddress;
  final String? status;
  final DateTime? dateTime;
  final double? fare;
  final double? charge;
  final double? totalFare;
  final double? refPer;

  PassengerOngoingRidesModel({
    this.jobId,
    this.userName,
    this.seat,
    this.fromAddress,
    this.toAddress,
    this.status,
    this.dateTime,
    this.fare,
    this.charge,
    this.totalFare,
    this.refPer,
  });

  /// Create an instance from JSON
  factory PassengerOngoingRidesModel.fromJson(Map<String, dynamic> json) {
    return PassengerOngoingRidesModel(
      jobId: json['jobId'] as String?,
      userName: json['userName'] as String?,
      seat: json['seat'] != null ? int.tryParse(json['seat'].toString()) : null,
      fromAddress: json['fromAddress'] as String?,
      toAddress: json['toAddress'] as String?,
      status: json['status'] as String?,
      dateTime: json['dateTime'] != null ? DateTime.tryParse(json['dateTime']) : null,
      fare: json['fare'] != null ? double.tryParse(json['fare'].toString()) : null,
      charge: json['charge'] != null ? double.tryParse(json['charge'].toString()) : null,
      totalFare: json['totalFare'] != null ? double.tryParse(json['totalFare'].toString()) : null,
      refPer: json['refPer'] != null ? double.tryParse(json['refPer'].toString()) : null,
    );
  }

  /// Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'userName': userName,
      'seat': seat,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'status': status,
      'dateTime': dateTime?.toIso8601String(),
      'fare': fare,
      'charge': charge,
      'totalFare': totalFare,
      'refPer': refPer,
    };
  }

  @override
  String toString() {
    return 'RideJob(jobId: $jobId, userName: $userName, seat: $seat, fromAddress: $fromAddress, toAddress: $toAddress, status: $status, dateTime: $dateTime, fare: $fare, charge: $charge, totalFare: $totalFare, refPer: $refPer)';
  }
}