import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/manager.dart';
import 'package:foody_app/data/model/orders_management.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ManagerApi)
class ManagerApiImpl implements ManagerApi {
  final ApiClient apiClient;

  const ManagerApiImpl(this.apiClient);

  @override
  Future<void> fireEmployee(int restaurant, int employee) async {
    await apiClient.delete('/restaurant/$restaurant/employee/$employee');
  }

  @override
  Future<List<OrdersManagement>> getEmployees(int restaurant) async {
    final result = await apiClient.get('/restaurant/$restaurant/employee/')
        as List<dynamic>;
    return result.map((e) => OrdersManagement.fromJson(e)).toList();
  }

  @override
  Future<void> hireEmployeeByEmail(int restaurant, String email) async {
    await apiClient.post('/restaurant/$restaurant/employee/', email);
  }
}
