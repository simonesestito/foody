import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:injectable/injectable.dart';

import '../orders.dart';

@Injectable(as: CustomerOrdersApi)
class CustomerOrdersApiImpl implements CustomerOrdersApi {
  final ApiClient apiClient;

  CustomerOrdersApiImpl(this.apiClient);

  @override
  Future<void> deleteOrder(Order order) async {
    await apiClient.delete('/orders/${order.id!}');
  }

  @override
  Future<Order> getOrder(int id) async {
    // Only allowed to restaurant's manager or customer
    final result = await apiClient.get('/orders/$id');
    return Order.fromJson(result);
  }

  @override
  Future<List<Order>> getMyOrders() async {
    final result = await apiClient.get('/customer/orders') as List<dynamic>;
    return result.map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<List<Order>> getRestaurantOrders(int restaurantId) async {
    final result = await apiClient.get('/restaurant/$restaurantId/orders')
        as List<dynamic>;
    return result.map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<void> postOrder(Address shippingAddress) async {
    await apiClient.post('/customer/orders', shippingAddress.toJson());
  }

  @override
  Future<void> updateOrderState(int orderId, OrderState state) async {
    // Only allowed by a worker for the order's restaurant
    await apiClient.post('/orders/$orderId/state/$state', {});
  }
}
