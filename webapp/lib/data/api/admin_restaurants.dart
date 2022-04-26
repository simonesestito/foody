import 'package:foody_app/data/model/restaurant.dart';

abstract class AdminRestaurantsApi {
  Future<List<RestaurantWithMenu>> getAll();

  Future<void> addRestaurant(Restaurant restaurant, String managerEmail);

  Future<void> updateRestaurant(Restaurant restaurant);

  Future<void> deleteRestaurant(int restaurant);
}
