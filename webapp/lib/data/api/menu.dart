import 'package:foody_app/data/model/menu.dart';

abstract class MenuApi {
  Future<void> addMenu(RestaurantMenu menu);

  Future<void> deleteMenu(RestaurantMenu menu);

  Future<void> addCategory(MenuCategory category);

  Future<void> removeCategory(int id);

  Future<void> addProductToCategory(int productId, int categoryId);

  Future<void> removeProductFromCategory(int productId, int categoryId);
}
