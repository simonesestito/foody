import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:foody_app/data/model/user.dart';

abstract class RiderApi {
  Future<RiderService> startService(User rider, GpsLocation location);

  Future<List<RiderService>> listServices(int riderId);

  Future<RiderService> endService(RiderService riderService);

  Future<RiderService> updateLocation(
    RiderService riderService,
    GpsLocation location,
  );

  Future<RiderService> getService(int riderId);

  Future<List<Order>> listAvailableOrders(GpsLocation fromLocation);

  Future<Order> deliverOrder(Order order);

  Future<Order> markOrderAsDelivered(Order order);
}
