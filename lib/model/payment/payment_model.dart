class PaymentModel {
  String? id;
  String? userId;
  String? userName;
  String? userProfileImage;
  String? providerId;
  String? jobId;
  double? amount;
  double? charge;
  bool? isRefundRequested;
  String? status;
  String? createdAt;
  String? updatedAt;

  PaymentModel({
    this.id,
    this.userId,
    this.userName,
    this.userProfileImage,
    this.providerId,
    this.jobId,
    this.amount,
    this.charge,
    this.isRefundRequested,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'],
      userId: json['userId']?['_id'] ?? json['userId']?['id'],
      userName: json['userId']?['name'],
      userProfileImage: json['userId']?['profileImage'],
      providerId: json['providerId'],
      jobId: json['jobId'],
      amount: json['amount']?.toDouble(),
      charge: json['charge']?.toDouble(),
      isRefundRequested: json['isRefundRequested'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
