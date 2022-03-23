import 'package:foody_app/data/model/menu.dart';

abstract class MenuApi {
  Future<List<RestaurantMenu>> getRestaurantMenus(int restaurantId);

  Future<RestaurantMenu> addMenu(int restaurantId, RestaurantMenu menu);

  Future<void> deleteMenu(RestaurantMenu menu);

  Future<RestaurantMenu> setPublished(RestaurantMenu menu, bool published);
}
