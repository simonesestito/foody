import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RiderServiceApi)
class RiderServiceApiImpl implements RiderServiceApi {
  final ApiClient apiClient;

  const RiderServiceApiImpl(this.apiClient);

  @override
  Future<void> beginOrderDelivery(int order) async {
    await apiClient.post('/service/deliver/$order', {});
  }

  @override
  Future<void> endOrderDelivery(int order) async {
    await apiClient.delete('/service/deliver/$order');
  }

  @override
  Future<void> endService() async {
    await apiClient.delete('/service/');
  }

  @override
  Future<RiderService?> getActiveService() async {
    final result = await apiClient.get('/service/active');
    return RiderService.fromJson(result);
  }

  @override
  Future<List<RiderService>> getAllPast() async {
    final result = await apiClient.get('/service/') as List<dynamic>;
    return result.map((e) => RiderService.fromJson(e)).toList();
  }

  @override
  Future<List<Order>> getOrdersForService(int service) async {
    final result =
        await apiClient.get('/service/$service/orders') as List<dynamic>;
    return result.map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<void> startService(GpsLocation location) async {
    await apiClient.post('/service/', location);
  }

  @override
  Future<void> updateLocation(GpsLocation location) async {
    await apiClient.post('/service/location', location);
  }

  @override
  Future<Order?> getDeliveringOrder() async {
    final result = await apiClient.get('/service/deliver');
    return result == null ? null : Order.fromJson(result);
  }
}
