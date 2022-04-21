import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/orders.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/order_details.dart';
import 'package:foody_app/routes/manager/list_employees.dart';
import 'package:foody_app/routes/manager/list_menus.dart';
import 'package:foody_app/routes/manager/list_products.dart';
import 'package:foody_app/routes/manager/timetable.dart';

class RestaurantOrders extends SingleChildBaseRoute {
  const RestaurantOrders({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ordini ristorante ${restaurant.name}',
            style: Theme.of(context).textTheme.headline4,
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RestaurantTimetable(),
                    settings: RouteSettings(arguments: restaurant),
                  ));
            },
            icon: const Icon(Icons.access_time),
            label: const Text('Gestisci orari di apertura'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListProductsRoute(),
                    settings: RouteSettings(arguments: restaurant),
                  ));
            },
            icon: const Icon(Icons.restaurant),
            label: const Text('Gestisci prodotti'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeesRoute(),
                    settings: RouteSettings(arguments: restaurant),
                  ));
            },
            icon: const Icon(Icons.badge),
            label: const Text('Gestisci dipendenti'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListMenusRoute(),
                    settings: RouteSettings(arguments: restaurant),
                  ));
            },
            icon: const Icon(Icons.menu_book),
            label: const Text('Gestisci menu e categorie'),
          ),
          FutureBuilder<List<Order>>(
            future: getIt
                .get<CustomerOrdersApi>()
                .getRestaurantOrders(restaurant.id),
            builder: (context, snap) {
              if (snap.hasError) {
                handleApiError(snap.error!, context);
                return ErrorWidget(snap.error!);
              }

              if (!snap.hasData) {
                return const SizedBox.square(
                  dimension: 36,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final order in snap.data!)
                    ListTile(
                      title: Text('#${order.id}'),
                      subtitle: Text(order.creation.toString()),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          OrderDetailsRoute.routeName,
                          arguments: order,
                        );
                      },
                    ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
