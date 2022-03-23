import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final String address;
  final String? houseNumber;
  final GpsLocation location;

  const Address({
    required this.address,
    required this.houseNumber,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
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
}
