import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rider_service.g.dart';

@JsonSerializable()
class RiderService {
  final int? id;
  final GpsLocation startLocation;
  final GpsLocation lastLocation;
  final DateTime start;
  final DateTime? end;
  final User user;

  const RiderService({
    this.id,
    required this.startLocation,
    required this.lastLocation,
    required this.start,
    required this.end,
    required this.user,
  });

  get isActive => end == null;

  factory RiderService.fromJson(Map<String, dynamic> json) =>
      _$RiderServiceFromJson(json);

  Map<String, dynamic> toJson() => _$RiderServiceToJson(this);
}
