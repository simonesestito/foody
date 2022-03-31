import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/model/cart_product.dart';
import 'package:injectable/injectable.dart';

import '../cart.dart';

@Injectable(as: CartApi)
class CartApiImpl implements CartApi {
  final ApiClient apiClient;

  CartApiImpl(this.apiClient);

  @override
  Future<List<CartProduct>> getCart() async {
    final result = await apiClient.get('/customer/cart/') as List<dynamic>;
    return result.map((json) => CartProduct.fromJson(json)).toList();
  }

  @override
  Future<void> insertInCart(CartProduct cartProduct) async {
    await apiClient.post('/customer/cart/', {
      'product': cartProduct.product.id,
      'quantity': cartProduct.quantity,
    });
  }
}
