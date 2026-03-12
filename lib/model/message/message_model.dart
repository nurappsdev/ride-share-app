class MessageResponse {
  int? code;
  List<MessageModel>? data;
  PaginationModel? pagination;
  ExtraModel? extra;

  MessageResponse({
    this.code,
    this.data,
    this.pagination,
    this.extra,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    code: json["code"],
    data: json["data"] == null
        ? []
        : List<MessageModel>.from(
        json["data"]!.map((x) => MessageModel.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : PaginationModel.fromJson(json["pagination"]),
    extra: json["extra"] == null
        ? null
        : ExtraModel.fromJson(json["extra"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
    "extra": extra?.toJson(),
  };
}

class MessageModel {
  String? id;
  String? senderId;
  String? threadId;
  String? content;
  List<dynamic>? attachments;
  List<String>? receivedBy;
  List<String>? readBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  MessageModel({
    this.id,
    this.senderId,
    this.threadId,
    this.content,
    this.attachments,
    this.receivedBy,
    this.readBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["_id"],
    senderId: json["senderId"],
    threadId: json["threadId"],
    content: json["content"],
    attachments: json["attachments"] == null
        ? []
        : List<dynamic>.from(json["attachments"]!.map((x) => x)),
    receivedBy: json["receivedBy"] == null
        ? []
        : List<String>.from(json["receivedBy"]!.map((x) => x)),
    readBy: json["readBy"] == null
        ? []
        : List<String>.from(json["readBy"]!.map((x) => x)),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "senderId": senderId,
    "threadId": threadId,
    "content": content,
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x)),
    "receivedBy": receivedBy == null
        ? []
        : List<dynamic>.from(receivedBy!.map((x) => x)),
    "readBy": readBy == null
        ? []
        : List<dynamic>.from(readBy!.map((x) => x)),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
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

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "itemsPerPage": itemsPerPage,
  };
}

class ExtraModel {
  String? threadId;

  ExtraModel({
    this.threadId,
  });

  factory ExtraModel.fromJson(Map<String, dynamic> json) => ExtraModel(
    threadId: json["threadId"],
  );

  Map<String, dynamic> toJson() => {
    "threadId": threadId,
  };
}