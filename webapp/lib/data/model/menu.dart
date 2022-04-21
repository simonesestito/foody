import 'package:json_annotation/json_annotation.dart';

import 'menu_product.dart';

part 'menu.g.dart';

@JsonSerializable()
class RestaurantMenu {
  final int? id;
  final String title;
  final bool published;
  final List<MenuCategory> categories;
  final int restaurant;

  const RestaurantMenu({
    this.id,
    required this.title,
    required this.published,
    required this.categories,
    required this.restaurant,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) =>
      _$RestaurantMenuFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantMenuToJson(this);
}

@JsonSerializable()
class MenuCategory {
  final int? id;
  final String title;
  final List<MenuProduct> products;
  final int menu;

  const MenuCategory({
    this.id,
    required this.title,
    required this.products,
    required this.menu,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryToJson(this);
}
