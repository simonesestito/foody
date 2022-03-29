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

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumbers,
    required this.openingHours,
    required this.averageRating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}

@JsonSerializable()
class DetailedRestaurant {
  final Restaurant restaurant;
  final List<RestaurantMenu> menus;

  const DetailedRestaurant({
    required this.restaurant,
    required this.menus,
  });

  factory DetailedRestaurant.fromJson(Map<String, dynamic> json) =>
      _$DetailedRestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedRestaurantToJson(this);
}
