import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:json_annotation/json_annotation.dart';

import 'opening_hours.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final int id;
  final String name;
  final Address address;
  final List<String> phoneNumbers;
  final List<OpeningHours> openingHours;
  final double? averageRating;
  final List<RestaurantMenu> menus;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumbers,
    required this.openingHours,
    required this.averageRating,
    required this.menus,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  List<OpeningHours> get sortedOpeningHours {
    openingHours.sort((a, b) {
      if (a.weekday != b.weekday) {
        return a.weekday - b.weekday;
      }

      final aTime = a.openingTime.hour * 60 + a.openingTime.minute;
      final bTime = b.openingTime.hour * 60 + b.openingTime.minute;
      return aTime - bTime;
    });
    return openingHours;
  }
}