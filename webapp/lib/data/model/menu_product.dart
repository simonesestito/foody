import 'package:json_annotation/json_annotation.dart';

part 'menu_product.g.dart';

@JsonSerializable()
class MenuProduct {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final List<Allergen> allergens;

  const MenuProduct({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.allergens,
  });

  factory MenuProduct.fromJson(Map<String, dynamic> json) =>
      _$MenuProductFromJson(json);

  Map<String, dynamic> toJson() => _$MenuProductToJson(this);
}

enum Allergen {
  cereals,
  crustaceans,
  eggs,
  fish,
  peanuts,
  soybeans,
  milk,
  nuts,
  celery,
  mustard,
  sesame,
  sulphurDioxide,
  lupin,
  molluscs,
}
