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

    return SliverToBoxAdapter(
      child: FutureBuilder<Restaurant>(
        future: Future.value(restaurant),
        builder: (context, snap) {
          if (snap.hasError) {
            return ErrorWidget(snap.error!);
          } else if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final restaurant = snap.data!;
            return Column(children: [
              Text(
                restaurant.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(restaurant.address.toString()),
              Text('Valutazione media: ${restaurant.averageRating}'),
              for (final phone in restaurant.phoneNumbers)
                Text('Telefono: $phone'),
              for (final open in restaurant.openingHours)
                Text(open.toString()),
              Text('Menu', style: Theme.of(context).textTheme.headline5),
              const Text('TODO'), // TODO: Show menu
            ]);
          }
        },
      ),
    );
  }
}
