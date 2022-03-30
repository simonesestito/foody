import 'package:flutter/material.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/index.dart';
import 'package:foody_app/widgets/bottom_sheet.dart';

class RestaurantDetailsRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.customer.routePrefix + '/restaurantDetails';

  const RestaurantDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurant =
        ModalRoute.of(context)?.settings.arguments as Restaurant?;

    if (restaurant == null) {
      Future.microtask(
        () =>
            Navigator.of(context).pushReplacementNamed(CustomerRoute.routeName),
      );
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

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
        ..._buildMenu(restaurant.menus.firstWhere((m) => m.published), context),
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
                  onPressed: () {
                    // TODO: Add to cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Da aggiungere -- TODO')),
                    );
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
