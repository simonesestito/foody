import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_product.g.dart';

@CopyWith()
@JsonSerializable()
class CartProduct {
  final MenuProduct product;
  final int quantity;

  const CartProduct({
    required this.product,
    required this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}
