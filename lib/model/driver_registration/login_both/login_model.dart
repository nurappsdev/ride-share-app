class LoginUserModel {
  final String? id;
  final String? name;
  final String? email;
  final LocationModel? location;
  final String? profileImage;
  final String? role;
  final String? status;
  final bool? isEmailVerified;
  final bool? isResetPassword;
  final bool? isDeleted;
  final int? failedLoginAttempts;
  final int? step;
  final double? avgRating;
  final int? totalRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  LoginUserModel({
    this.id,
    this.name,
    this.email,
    this.location,
    this.profileImage,
    this.role,
    this.status,
    this.isEmailVerified,
    this.isResetPassword,
    this.isDeleted,
    this.failedLoginAttempts,
    this.step,
    this.avgRating,
    this.totalRating,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      isResetPassword: json['isResetPassword'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      failedLoginAttempts: json['failedLoginAttempts'] as int?,
      step: json['step'] as int?,
      avgRating: (json['avgRating'] as num?)?.toDouble(),
      totalRating: json['totalRating'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'location': location?.toJson(),
      'profileImage': profileImage,
      'role': role,
      'status': status,
      'isEmailVerified': isEmailVerified,
      'isResetPassword': isResetPassword,
      'isDeleted': isDeleted,
      'failedLoginAttempts': failedLoginAttempts,
      'step': step,
      'avgRating': avgRating,
      'totalRating': totalRating,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }

  @override
  String toString() {
    return '''
UserModel(
  id: $id,
  name: $name,
  email: $email,
  location: $location,
  profileImage: $profileImage,
  role: $role,
  status: $status,
  isEmailVerified: $isEmailVerified,
  isResetPassword: $isResetPassword,
  isDeleted: $isDeleted,
  failedLoginAttempts: $failedLoginAttempts,
  step: $step,
  avgRating: $avgRating,
  totalRating: $totalRating,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
  version: $version
)
''';
  }
}

class LocationModel {
  final String? type;
  final List<double>? coordinates;

  LocationModel({
    this.type,
    this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  @override
  String toString() {
    return 'LocationModel(type: $type, coordinates: $coordinates)';
  }
}
