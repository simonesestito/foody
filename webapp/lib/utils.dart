import 'package:flutter/material.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/globals.dart';
import 'package:geolocator/geolocator.dart';

extension ListUtils on List<Widget> {
  List<Widget> withMargin({double margin = Globals.standardMargin}) {
    return List.generate(
      2 * length - 1,
      (index) => index % 2 == 0
          ? this[index ~/ 2]
          : SizedBox.square(dimension: margin),
    );
  }
}

FormFieldValidator fieldValidator({bool Function(String)? then}) => (value) {
      if (value == null) return 'Campo mancante';
      if (value.length <= 3) return 'Campo troppo corto';
      if (value.length >= 255) return 'Campo troppo lungo';
      if (then?.call(value) == false) return 'Valore inserito errato';
      return null;
    };

bool phoneValidator(String value) {
  if (!value.startsWith('+')) {
    value = '+39$value';
  }

  const phoneNumberRegex =
      r'^\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$';
  return RegExp(phoneNumberRegex).hasMatch(value);
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<GpsLocation> getUserGpsLocation([
  GpsLocation defaultLocation = const GpsLocation(
    latitude: 41.9019257,
    longitude: 12.5147147,
  ),
]) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    debugPrint('Location services are disabled.');
    return defaultLocation;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('Location permissions are denied');
      return defaultLocation;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    debugPrint(
        'Location permissions are permanently denied, we cannot request permissions.');
    return defaultLocation;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  final position = await Geolocator.getCurrentPosition();
  return GpsLocation(
    latitude: position.latitude,
    longitude: position.longitude,
  );
}
