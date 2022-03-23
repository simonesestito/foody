import 'package:foody_app/data/model/order.dart';

abstract class CustomerOrdersApi {
  Future<List<Order>> getOrders();

  Future<Order> getOrder(int orderId);

  Future<Order> postOrder(Order order);

  Future<void> deleteOrder(Order order);

  Future<List<Order>> getRestaurantOrders(int restaurantId);

  Future<Order> updateOrderState(int orderId, OrderState state);
}
