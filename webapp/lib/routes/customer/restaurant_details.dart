import 'package:flutter/material.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';

class RestaurantDetailsRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.customer.routePrefix + '/restaurantDetails';

  const RestaurantDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurant = ModalRoute.of(context)?.settings.arguments as Restaurant;
    // FIXME: DetailedRestaurant required

    return SliverToBoxAdapter(
      child: FutureBuilder<DetailedRestaurant>(
        future: Future.value(DetailedRestaurant(
          restaurant: restaurant,
          menus: [],
        )),
        builder: (context, snap) {
          if (snap.hasError) {
            return ErrorWidget(snap.error!);
          } else if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final restaurant = snap.data!;
            return Column(children: [
              Text(
                restaurant.restaurant.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(restaurant.restaurant.address.toString()),
              Text('Valutazione media: ${restaurant.restaurant.averageRating}'),
              for (final phone in restaurant.restaurant.phoneNumbers)
                Text('Telefono: $phone'),
              for (final open in restaurant.restaurant.openingHours)
                Text(open.toString()),
              Text('Menu', style: Theme.of(context).textTheme.headline5),
              const Text('TODO'),
            ]);
          }
        },
      ),
    );
  }
}
