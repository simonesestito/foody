import 'package:foody_app/data/model/cart_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int? id;
  final OrderState state;
  final List<CartProduct> products;

  const Order({
    this.id,
    required this.state,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

enum OrderState {
  preparing,
  prepared,
  delivering,
  delivered,
}
