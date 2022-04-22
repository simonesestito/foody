
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RiderServiceApi)
class RiderServiceApiImpl implements RiderServiceApi {
  @override
  Future<void> beginOrderDelivery(int order) async {
    // TODO: implement beginOrderDelivery
    throw UnimplementedError();
  }

  @override
  Future<void> endOrderDelivery(int order) async {
    // TODO: implement endOrderDelivery
    throw UnimplementedError();
  }

  @override
  Future<void> endService() async {
    // TODO: implement endService
    throw UnimplementedError();
  }

  @override
  Future<RiderService?> getActiveService() async {
    // TODO: implement getActiveService
    throw UnimplementedError();
  }

  @override
  Future<List<RiderService>> getAll() async {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<Order>> getOrdersForService(int service) async {
    // TODO: implement getOrdersForService
    throw UnimplementedError();
  }

  @override
  Future<void> startService(GpsLocation location) async {
    // TODO: implement startService
    throw UnimplementedError();
  }

  @override
  Future<void> updateLocation(GpsLocation location) async {
    // TODO: implement updateLocation
    throw UnimplementedError();
  }
  
}