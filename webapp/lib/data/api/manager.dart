import 'package:foody_app/data/model/orders_management.dart';

abstract class ManagerApi {
  Future<List<OrdersManagement>> getEmployees(int restaurant);

  Future<void> hireEmployeeByEmail(int restaurant, String email);

  Future<void> fireEmployee(int restaurant, int employee);
}
