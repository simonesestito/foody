import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/products.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';

/// Picked product is set in Navigator result
class PickProductRoute extends SingleChildBaseRoute {
  final int restaurantId;

  const PickProductRoute({
    required this.restaurantId,
    Key? key,
  }) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<MenuProduct>>(
        future: getIt.get<ProductsApi>().getProducts(restaurantId),
        builder: (context, snap) {
          if (snap.hasError) {
            handleApiError(snap.error!, context);
            return ErrorWidget(snap.error!);
          }

          if (!snap.hasData) {
            return const SizedBox.square(
              dimension: 36,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            children: [
              Text(
                'Scegli prodotto',
                style: Theme.of(context).textTheme.headline4,
              ),
              for (final product in snap.data!)
                ListTile(
                  title: Text(product.name),
                  onTap: () => Navigator.pop(context, product),
                ),
            ],
          );
        },
      ),
    );
  }
}
