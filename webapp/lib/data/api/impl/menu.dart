import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/menu.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MenuApi)
class MenuApiImpl implements MenuApi {
  final ApiClient apiClient;

  const MenuApiImpl(this.apiClient);

  @override
  Future<void> addMenu(int restaurantId, RestaurantMenu menu) async {
    await apiClient.post('/menu/', menu.toJson());
  }

  @override
  Future<void> deleteMenu(RestaurantMenu menu) async {
    await apiClient.delete('/menu/${menu.id!}');
  }

  @override
  Future<void> removeCategory(int id) async {
    await apiClient.delete('/menu/category/$id');
  }
}
