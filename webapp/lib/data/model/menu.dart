import 'package:json_annotation/json_annotation.dart';

import 'menu_product.dart';

part 'menu.g.dart';

@JsonSerializable()
class RestaurantMenu {
  final int? id;
  final String title;
  final bool published;
  final List<MenuCategory> categories;

  const RestaurantMenu({
    this.id,
    required this.title,
    required this.published,
    required this.categories,
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

  const MenuCategory({
    this.id,
    required this.title,
    required this.products,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryToJson(this);
}
