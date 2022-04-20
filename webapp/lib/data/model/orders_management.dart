import 'package:foody_app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orders_management.g.dart';

@JsonSerializable()
class OrdersManagement {
  final DateTime startDate;
  final DateTime? endDate;
  final User user;
  final int restaurant;

  const OrdersManagement({
    required this.startDate,
    required this.endDate,
    required this.user,
    required this.restaurant,
  });

  factory OrdersManagement.fromJson(Map<String, dynamic> json) =>
      _$OrdersManagementFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersManagementToJson(this);
}
