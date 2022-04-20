import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/products.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/manager/edit_product.dart';

class ListProductsRoute extends BaseRoute {
  const ListProductsRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    return [
      Text(
        'Prodotti',
        style: Theme.of(context).textTheme.headline4,
      ),
      _ListProductsContent(restaurant: restaurant),
    ].map((e) => SliverToBoxAdapter(child: e)).toList();
  }
}

class _ListProductsContent extends StatefulWidget {
  final Restaurant restaurant;

  const _ListProductsContent({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  State<_ListProductsContent> createState() => _ListProductsContentState();
}

class _ListProductsContentState extends State<_ListProductsContent> {
  Key _listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuProduct>>(
      key: _listKey,
      future: getIt.get<ProductsApi>().getProducts(widget.restaurant.id),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProductRoute(),
                    settings: RouteSettings(arguments: widget.restaurant),
                  )).then((value) => setState(() {
                    _listKey = UniqueKey();
                  })),
              icon: const Icon(Icons.add),
              label: const Text('Crea nuovo'),
            ),
            for (final product in snap.data!)
              ListTile(
                title: Text(product.name),
                subtitle: Text(product.price.toStringAsFixed(2)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _onEditProduct(product),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _onDeleteProduct(product),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  void _onEditProduct(MenuProduct product) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditProductRoute(product: product),
          settings: RouteSettings(arguments: widget.restaurant),
        ),
      );
      setState(() {
        _listKey = UniqueKey();
      });
    } catch (e) {
      handleApiError(e, context);
    }
  }

  void _onDeleteProduct(MenuProduct product) async {
    try {
      await getIt.get<ProductsApi>().deleteProduct(product);
      setState(() {
        _listKey = UniqueKey();
      });
    } catch (e) {
      handleApiError(e, context);
    }
  }
}
