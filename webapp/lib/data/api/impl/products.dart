import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/products.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductsApi)
class ProductsApiImpl implements ProductsApi {
  final ApiClient apiClient;

  const ProductsApiImpl(this.apiClient);

  @override
  Future<void> addProduct(MenuProduct menuProduct) async {
    await apiClient.post('/products/', menuProduct.toJson());
  }

  @override
  Future<void> deleteProduct(MenuProduct menuProduct) async {
    await apiClient.delete('/products/${menuProduct.id}');
  }

  @override
  Future<MenuProduct> getProduct(int productId) async {
    final result = await apiClient.get('/products/$productId');
    return MenuProduct.fromJson(result);
  }

  @override
  Future<List<MenuProduct>> getProducts(int restaurantId) async {
    final results = await apiClient.get('/restaurant/$restaurantId/products')
        as List<dynamic>;
    return results.map((e) => MenuProduct.fromJson(e)).toList();
  }
}
