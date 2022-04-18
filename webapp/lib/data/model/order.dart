import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/cart_product.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
@_OrderStateConverter()
class Order {
  final int? id;
  final OrderState status;
  final List<CartProduct> orderContent;
  final Address address;
  final DateTime creation;
  final RiderService? riderService;
  final User user;

  const Order({
    this.id,
    required this.status,
    required this.orderContent,
    required this.address,
    required this.creation,
    required this.user,
    this.riderService,
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

class _OrderStateConverter implements JsonConverter<OrderState, int> {
  const _OrderStateConverter();

  @override
  OrderState fromJson(int json) {
    switch (json) {
      case 100:
        return OrderState.preparing;
      case 200:
        return OrderState.prepared;
      case 300:
        return OrderState.delivering;
      case 400:
        return OrderState.delivered;
      default:
        throw ArgumentError.value(json, 'OrderState', 'Invalid integer state');
    }
  }

  @override
  int toJson(OrderState object) {
    switch (object) {
      case OrderState.preparing:
        return 100;
      case OrderState.prepared:
        return 200;
      case OrderState.delivering:
        return 300;
      case OrderState.delivered:
        return 400;
    }
  }
}
