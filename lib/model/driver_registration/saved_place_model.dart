class SavedPlaceModel {
  final double latitude;
  final double longitude;
  final String address;

  SavedPlaceModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory SavedPlaceModel.fromJson(Map<String, dynamic> json) {
    return SavedPlaceModel(
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'SavedPlaceModel(address: $address, lat: $latitude, lng: $longitude)';
  }
}