import 'package:foody_app/data/model/menu_product.dart';

abstract class ProductsApi {
  Future<List<MenuProduct>> getProducts(int restaurantId);

  Future<MenuProduct> getProduct(int productId);

  Future<MenuProduct> addProduct(MenuProduct menuProduct);

  Future<MenuProduct> updateProduct(MenuProduct menuProduct);

  Future<void> deleteProduct(MenuProduct menuProduct);
}
