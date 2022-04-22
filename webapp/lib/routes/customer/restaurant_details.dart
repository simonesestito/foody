import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/data/api/cart.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/cart_product.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/index.dart';
import 'package:foody_app/widgets/bottom_sheet.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:foody_app/widgets/snackbar.dart';

class RestaurantDetailsRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.cliente.routePrefix + '/restaurantDetails';

  const RestaurantDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurant =
        ModalRoute.of(context)?.settings.arguments as RestaurantWithMenu?;

    if (restaurant == null) {
      Future.microtask(
        () =>
            Navigator.of(context).pushReplacementNamed(CustomerRoute.routeName),
      );
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    restaurant.menus.retainWhere((m) => m.published);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Text(
          restaurant.name,
          style: Theme.of(context).textTheme.headline4,
        ),
        ListTile(
          title: const Text('Indirizzo'),
          subtitle: Text(restaurant.address.toString()),
          leading: const Icon(Icons.place),
        ),
        ListTile(
          title: const Text('Valutazione media'),
          subtitle: Text(
            restaurant.averageRating?.toString() ?? 'Non disponibile',
          ),
          leading: const Icon(Icons.star),
        ),
        const Divider(),
        for (final phone in restaurant.phoneNumbers)
          ListTile(
            title: const Text('Numero di telefono'),
            subtitle: Text(phone),
            leading: const Icon(Icons.phone),
          ),
        const ListTile(
          title: Text('Orari di apertura'),
          leading: Icon(Icons.calendar_today),
        ),
        for (final open in restaurant.sortedOpeningHours) Text(open.toString()),
        const Divider(),
        if (restaurant.menus.isEmpty)
          const Text('Nessun menu pubblicato')
        else
          ..._buildMenu(restaurant.menus.first, context),
        LoadingButton(
            label: const Text('Vedi recensioni'),
            onPressed: () async {
              final reviews = await getIt.get<RestaurantsApi>().getReviews(
                    restaurant.id,
                  );
              showAppBottomSheet(context, (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final review in reviews
                        .where((r) => r.title != null || r.description != null))
                      ListTile(
                        leading: Text(review.mark.toString()),
                        title: Text(review.user.fullName),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.title ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(review.description ?? ''),
                          ],
                        ),
                      ),
                  ],
                );
              });
            }),
      ]),
    );
  }

  List<Widget> _buildMenu(RestaurantMenu menu, BuildContext context) {
    final list = List<Widget>.of([
      Text('Menu', style: Theme.of(context).textTheme.headline5),
    ], growable: true);

    for (final category in menu.categories) {
      list.add(
        Text(category.title, style: Theme.of(context).textTheme.bodyLarge),
      );

      for (final product in category.products) {
        list.add(
          ListTile(
            title:
                Text('${product.name} - ${product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (product.allergens.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      showAppBottomSheet(context, (context) {
                        return Column(children: [
                          Text(
                            'Allergeni - ${product.name}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          for (final allergen in product.allergens)
                            Text(allergen.displayName)
                        ]);
                      });
                    },
                    icon: const Icon(Icons.info_outline),
                  ),
                IconButton(
                  onPressed: () async {
                    try {
                      await getIt.get<CartApi>().insertInCart(CartProduct(
                            product: product,
                            quantity: 1,
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackbar(
                          content: 'Aggiunto al carrello',
                          context: context,
                        ),
                      );
                    } catch (err) {
                      handleApiError(err, context);
                    }
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                ),
              ],
            ),
            subtitle:
                product.description == null ? null : Text(product.description!),
          ),
        );
      }
    }

    return list;
  }
}
