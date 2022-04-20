import 'package:json_annotation/json_annotation.dart';

part 'menu_product.g.dart';

@JsonSerializable()
class MenuProduct {
  final int id;
  final String name;
  final String? description;
  final double price;
  final List<Allergen> allergens;
  final int restaurant;

  const MenuProduct({
    this.id = -1,
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
  arachidi,
  cereali,
  crostacei,
  latte,
  lupini,
  molluschi,
  noci,
  pesce,
  sedano,
  senape,
  sesamo,
  soia,
  solfiti,
  uova,
}

extension DisplayAllergen on Allergen {
  String get displayName {
    switch (this) {
      case Allergen.cereali:
        return 'Glutine';
      case Allergen.crostacei:
        return 'Crostacei';
      case Allergen.uova:
        return 'Uova';
      case Allergen.pesce:
        return 'Pesce';
      case Allergen.arachidi:
        return 'Arachidi';
      case Allergen.soia:
        return 'Soia';
      case Allergen.latte:
        return 'Latte';
      case Allergen.noci:
        return 'Frutta a guscio';
      case Allergen.sedano:
        return 'Sedano';
      case Allergen.senape:
        return 'Senape';
      case Allergen.sesamo:
        return 'Sesamo';
      case Allergen.solfiti:
        return 'Solfiti';
      case Allergen.lupini:
        return 'Lupini';
      case Allergen.molluschi:
        return 'Molluschi';
    }
  }
}
