import 'package:foody_app/data/api/admin_restaurants.dart';
import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AdminRestaurantsApi)
class AdminRestaurantsApiImpl implements AdminRestaurantsApi {
  final ApiClient apiClient;

  const AdminRestaurantsApiImpl(this.apiClient);

  @override
  Future<void> addRestaurant(Restaurant restaurant, String managerEmail) async {
    await apiClient.post(
      '/admin/restaurants/$managerEmail',
      restaurant.toJson(),
    );
  }

  @override
  Future<void> deleteRestaurant(int restaurant) async {
    await apiClient.delete('/admin/restaurants/$restaurant');
  }

  @override
  Future<List<RestaurantWithMenu>> getAll() async {
    final result = await apiClient.get('/admin/restaurants/') as List<dynamic>;
    return result.map((e) => RestaurantWithMenu.fromJson(e)).toList();
  }

  @override
  Future<void> updateRestaurant(Restaurant restaurant) async {
    await apiClient.post('/admin/restaurants/', restaurant.toJson());
  }
}
