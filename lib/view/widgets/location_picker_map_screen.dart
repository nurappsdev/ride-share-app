import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'custom_button_common.dart';

class LocationPickerMapScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const LocationPickerMapScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  @override
  State<LocationPickerMapScreen> createState() =>
      _LocationPickerMapScreenState();
}

class _LocationPickerMapScreenState extends State<LocationPickerMapScreen> {
  late GoogleMapController mapController;
  late LatLng currentLocation;
  String address = 'Loading address...';
  bool isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(widget.initialLatitude, widget.initialLongitude);
    _getAddressFromLatLng(currentLocation);
  }

  /// Get address from coordinates
  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      isLoadingAddress = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        address = 'Unable to get address';
      });
    } finally {
      setState(() {
        isLoadingAddress = false;
      });
    }
  }

  /// Handle map tap
  void _onMapTapped(LatLng position) {
    setState(() {
      currentLocation = position;
    });
    _getAddressFromLatLng(position);
  }

  /// Confirm location selection
  void _confirmLocation() {
    Get.back(
      result: {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'address': address,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location'), elevation: 0),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: _onMapTapped,
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: currentLocation,
                draggable: true,
                onDragEnd: (LatLng position) {
                  _onMapTapped(position);
                },
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Address Card at Bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Selected Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Address Text
                    isLoadingAddress
                        ? const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Getting address...'),
                            ],
                          )
                        : Text(
                            address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),

                    const SizedBox(height: 16),

                    // Confirm Button
                    CustomButtonCommon(
                      title: 'Confirm Location',
                      useGradient: true,
                      onpress: () {
                        isLoadingAddress ? null : _confirmLocation();
                      },
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: isLoadingAddress ? null : _confirmLocation,
                    //     style: ElevatedButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(vertical: 14),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //     child: const Text(
                    //       'Confirm Location',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // Center Marker Hint (Optional)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.touch_app, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap or drag the marker to select location',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
