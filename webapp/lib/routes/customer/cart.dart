import 'package:flutter/material.dart';
import 'package:foody_app/data/api/cart.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/model/cart_product.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/order_confirm.dart';
import 'package:foody_app/widgets/snackbar.dart';

class ProductAndController {
  final CartProduct product;
  final TextEditingController controller;

  ProductAndController(this.product, this.controller);
}

class CartRoute extends BaseRoute {
  static final routeName = UserRole.cliente.routePrefix + '/cart';

  const CartRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [
        SliverToBoxAdapter(
          child: Text(
            'Carrello',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const SliverToBoxAdapter(child: _ProductsList())
      ];
}

class _ProductsList extends StatefulWidget {
  const _ProductsList({Key? key}) : super(key: key);

  @override
  State<_ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<_ProductsList> {
  List<ProductAndController> _productsWithController = [];
  Key _queryKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CartProduct>>(
      key: _queryKey,
      future: getIt.get<CartApi>().getCart(),
      builder: (context, snap) {
        if (snap.hasError) {
          handleApiError(snap.error!, context);
          return ErrorWidget(snap.error!);
        } else if (snap.hasData) {
          _productsWithController = snap.data!
              .map((e) => ProductAndController(
                    e,
                    TextEditingController(text: e.quantity.toString()),
                  ))
              .toList();

          final sum = snap.data!.isEmpty
              ? 0
              : snap.data!
                  .map((e) => e.product.price * e.quantity)
                  .reduce((value, element) => value + element);

          return Column(children: [
            Text(
              'Totale: €' + sum.toStringAsFixed(2),
              style: Theme.of(context).textTheme.headline5,
            ),
            OutlinedButton.icon(
              onPressed: () {
                if (snap.data?.isEmpty != false) {
                  ScaffoldMessenger.of(context).showSnackBar(AppSnackbar(
                    context: context,
                    content: 'Il carrello è vuoto',
                  ));
                } else {
                  Navigator.pushNamed(context, OrderConfirm.routeName);
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Conferma ordine'),
            ),
            for (final e in _productsWithController)
              ListTile(
                title: Text(
                  e.product.product.name +
                      ' - ' +
                      e.product.product.price.toStringAsFixed(2),
                ),
                subtitle: Text(e.product.product.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<int>(
                      value: e.product.quantity,
                      items: [
                        for (int q = 1; q <= 10; q++)
                          DropdownMenuItem(
                            value: q,
                            child: Text(q.toString()),
                          ),
                      ],
                      onChanged: (value) async {
                        await getIt.get<CartApi>().insertInCart(
                              e.product.copyWith(quantity: value),
                            );
                        setState(() {
                          _queryKey = UniqueKey();
                        });
                      },
                    ),
                    IconButton(
                      onPressed: () async {
                        await getIt.get<CartApi>().removeFromCart(e.product);
                        setState(() {
                          _queryKey = UniqueKey();
                        });
                      },
                      icon: const Icon(
                        Icons.remove_shopping_cart_rounded,
                      ),
                    ),
                  ],
                ),
              )
          ]);
        } else {
          return const SizedBox.square(
            child: Center(child: CircularProgressIndicator()),
            dimension: 32,
          );
        }
      },
    );
  }
}
