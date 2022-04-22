import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/manager/restaurant_orders.dart';

final managerRoutes = {
  ManagerRoute.routeName: (_) => const ManagerRoute(),
}.map((key, value) => MapEntry(UserRole.manager.routePrefix + key, value));

class ManagerRoute extends SingleChildBaseRoute {
  static const routeName = '';

  const ManagerRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
        child: FutureBuilder<List<RestaurantWithMenu>>(
      future: getIt.get<RestaurantsApi>().getMyRestaurants(),
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
            Text(
              'Scegli il ristorante da gestire',
              style: Theme.of(context).textTheme.headline4,
            ),
            for (final restaurant in snap.data!)
              ListTile(
                title: Text(restaurant.name),
                subtitle: Text(restaurant.address.toString()),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RestaurantOrders(),
                    settings: RouteSettings(arguments: restaurant),
                  ),
                ),
              ),
          ],
        );
      },
    ));
  }
}
