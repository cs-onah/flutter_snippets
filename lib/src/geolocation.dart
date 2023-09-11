import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationService {
  /// Default location
  static const LatLng lagos = LatLng(6.535422, 3.406448);

  static Position lagosPosition = Position(
    latitude: lagos.latitude,
    longitude: lagos.longitude,
    timestamp: DateTime.now(),
    isMocked: false,
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    floor: 0,
  );

  static Position? devicePosition;

  /// Returns current device Location
  Future<Position?> getCurrentLocation() async {
    try {
      await requestLocationPermission();

      /// getCurrentPosition() does not work if there is an ongoing location stream.
      if (_locationStream != null) return devicePosition;
      devicePosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      return devicePosition;
    } catch (e) {
      log("cannot get location: $e");
      return null;
    }
  }

  StreamSubscription<Position>? _locationStream;
  startLocationStream() async {
    _locationStream?.cancel();
    await requestLocationPermission();
    _locationStream = Geolocator.getPositionStream().listen((event) {
      devicePosition = event;
    });
  }

  cancelLocationStream() {
    _locationStream?.cancel();
    _locationStream = null;
  }

  Future<Placemark?> addressFromPosition(Position position) async {
    Placemark? result;
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      result = placeMarks.firstOrNull;
    } catch (_) {}
    return result;
  }

  Future<Location?> positionFromAddress(String address) async {
    Location? result;
    try {
      List<Location> locations = await locationFromAddress(address);
      result = locations.firstOrNull;
    } catch (_) {}
    return result;
  }

  // returns distance in meters
  double? distanceFromDevice(LatLng? location) {
    if (devicePosition == null) return null;
    if (location == null) return null;
    final meters = Geolocator.distanceBetween(
      devicePosition!.latitude,
      devicePosition!.longitude,
      location.latitude,
      location.longitude,
    );
    return meters;
  }

  /// Checks and requests for Location Permission
  ///
  /// returns bool based on location permission status.
  ///
  /// Android Permissions
  /// * < uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  /// * < uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  static Future<bool> requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  /// Provides a listenable location stream
  ///
  /// Usage: create a [StreamSubscription] to listen to stream.
  /// Remember to dispose [StreamSubscription] after use.
  static Stream<Position> positionStream() => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 3,
        ),
      );

  /// Generate Uint8List from image
  ///
  /// Generated Byte data can be used to create [BitmapDescriptor] for [Marker]
  /// ```dart
  /// imageData = await getBytesFromAsset('images/marker.png', 50);
  /// ```
  static Future<Uint8List> getBytesFromAsset(
    String path, {
    int width = 50,
  }) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}

extension PositionAddOns on Position {
  LatLng get latLng => LatLng(latitude, longitude);
}
