import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/menu.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MenuApi)
class MenuApiImpl implements MenuApi {
  final ApiClient apiClient;

  const MenuApiImpl(this.apiClient);

  @override
  Future<void> addMenu(RestaurantMenu menu) async {
    await apiClient.post('/menu/', menu.toJson());
  }

  @override
  Future<void> deleteMenu(RestaurantMenu menu) async {
    await apiClient.delete('/menu/${menu.id!}');
  }

  @override
  Future<void> addCategory(MenuCategory category) async {
    await apiClient.post('/menu/category', category.toJson());
  }

  @override
  Future<void> removeCategory(int id) async {
    await apiClient.delete('/menu/category/$id');
  }

  @override
  Future<void> addProductToCategory(int productId, int categoryId) async {
    await apiClient.post('/menu/category/$categoryId/product/$productId', {});
  }

  @override
  Future<void> removeProductFromCategory(int productId, int categoryId) async {
    await apiClient.delete('/menu/category/$categoryId/product/$productId');
  }
}
