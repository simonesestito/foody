import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/order.dart';

abstract class CustomerOrdersApi {
  Future<List<Order>> getMyOrders();

  Future<Order> getOrder(int id);

  Future<void> postOrder(Address shippingAddress);

  Future<void> deleteOrder(Order order);

  Future<List<Order>> getRestaurantOrders(int restaurantId);

  Future<void> updateOrderState(int orderId, OrderState state);
}
