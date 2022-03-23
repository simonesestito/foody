import 'package:foody_app/data/model/cart_product.dart';

abstract class CartApi {
  Future<List<CartProduct>> getCart();

  Future<void> insertInCart(CartProduct cartProduct);
}
