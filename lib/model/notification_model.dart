class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String receiverId;
  final String type;
  final bool viewStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.receiverId,
    required this.type,
    required this.viewStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      receiverId: json['receiverId'] ?? '',
      type: json['type'] ?? '',
      viewStatus: json['viewStatus'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'message': message,
      'receiverId': receiverId,
      'type': type,
      'viewStatus': viewStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Get formatted date (e.g., "3/12/2026")
  String get formattedDate {
    return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
  }

  /// Get formatted time (e.g., "9:41 AM")
  String get formattedTime {
    final hour = createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Get formatted date and time together
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }
}
