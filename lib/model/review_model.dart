class ReviewResponse {
  int? code;
  List<ReviewModel>? data;
  PaginationModel? pagination;

  ReviewResponse({this.code, this.data, this.pagination});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
    code: json["code"],
    data: json["data"] == null
        ? []
        : List<ReviewModel>.from(
        json["data"]!.map((x) => ReviewModel.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : PaginationModel.fromJson(json["pagination"]),
  );
}

class ReviewModel {
  String? id;
  String? userId;
  ReviewerId? reviewerId;
  double? rating;
  String? comment;
  String? createdAt;

  ReviewModel({
    this.id,
    this.userId,
    this.reviewerId,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["_id"],
    userId: json["userId"],
    reviewerId: json["reviewerId"] == null
        ? null
        : ReviewerId.fromJson(json["reviewerId"]),
    rating: json["rating"]?.toDouble(),
    comment: json["comment"] ?? '',
    createdAt: json["createdAt"],
  );
}

class ReviewerId {
  String? id;
  String? name;
  String? profileImage;
  String? role;

  ReviewerId({
    this.id,
    this.name,
    this.profileImage,
    this.role,
  });

  factory ReviewerId.fromJson(Map<String, dynamic> json) => ReviewerId(
    id: json["_id"],
    name: json["name"],
    profileImage: json["profileImage"],
    role: json["role"],
  );
}

class PaginationModel {
  int? totalCount;
  int? totalPages;
  int? currentPage;
  int? itemsPerPage;

  PaginationModel({
    this.totalCount,
    this.totalPages,
    this.currentPage,
    this.itemsPerPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      PaginationModel(
        totalCount: json["totalCount"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        itemsPerPage: json["itemsPerPage"],
      );
}