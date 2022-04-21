import 'package:foody_app/data/model/menu.dart';

abstract class MenuApi {
  Future<void> addMenu(int restaurantId, RestaurantMenu menu);

  Future<void> deleteMenu(RestaurantMenu menu);

  Future<void> removeCategory(int id);
}
