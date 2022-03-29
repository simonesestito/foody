import 'package:json_annotation/json_annotation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final String address;
  final String? houseNumber;
  final String city;
  final GpsLocation location;

  const Address({
    required this.address,
    required this.houseNumber,
    required this.city,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() => '$address, ${houseNumber ?? 'snc'}, $city';
}

@JsonSerializable()
class GpsLocation {
  final double latitude;
  final double longitude;

  const GpsLocation({
    required this.latitude,
    required this.longitude,
  });

  factory GpsLocation.fromJson(Map<String, dynamic> json) =>
      _$GpsLocationFromJson(json);

  Map<String, dynamic> toJson() => _$GpsLocationToJson(this);

  LatLng toLatLng() => LatLng(latitude, longitude);
}
