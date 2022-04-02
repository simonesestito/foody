import 'package:json_annotation/json_annotation.dart';

part 'menu_product.g.dart';

@JsonSerializable()
class MenuProduct {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final List<Allergen> allergens;
  final int restaurant;

  const MenuProduct({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.allergens,
    required this.restaurant,
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

extension DisplayAllergen on Allergen {
  String get displayName {
    switch (this) {
      case Allergen.cereals:
        return 'Glutine';
      case Allergen.crustaceans:
        return 'Crostacei';
      case Allergen.eggs:
        return 'Uova';
      case Allergen.fish:
        return 'Pesce';
      case Allergen.peanuts:
        return 'Arachidi';
      case Allergen.soybeans:
        return 'Soia';
      case Allergen.milk:
        return 'Latte';
      case Allergen.nuts:
        return 'Frutta a guscio';
      case Allergen.celery:
        return 'Sedano';
      case Allergen.mustard:
        return 'Senape';
      case Allergen.sesame:
        return 'Sesamo';
      case Allergen.sulphurDioxide:
        return 'Solfiti';
      case Allergen.lupin:
        return 'Lupini';
      case Allergen.molluscs:
        return 'Molluschi';
    }
  }
}
