import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/rider_service.dart';

abstract class RiderServiceApi {
  Future<RiderService?> getActiveService();

  Future<List<RiderService>> getAllPast();

  Future<List<Order>> getOrdersForService(int service);

  Future<void> startService(GpsLocation location);

  Future<void> endService();

  Future<void> updateLocation(GpsLocation location);

  Future<void> beginOrderDelivery(int order);

  Future<void> endOrderDelivery(int order);

  Future<Order?> getDeliveringOrder();
}