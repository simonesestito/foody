import 'package:flutter/material.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/customer_orders.dart';
import 'package:foody_app/widgets/map.dart';
import 'package:foody_app/widgets/snackbar.dart';

final customerRoutes = {
  CustomerRoute.routeName: (_) => const CustomerRoute(),
  CustomerOrdersRoute.routeName: (_) => const CustomerOrdersRoute(),
};

class CustomerRoute extends BaseRoute {
  static final routeName = UserRole.customer.routePrefix;

  const CustomerRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [
        SliverToBoxAdapter(
          child: Align(
            child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, CustomerOrdersRoute.routeName);
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('Visualizza ordini')),
          ),
        ),
        const SliverToBoxAdapter(
          child: _RestaurantsMap(),
        ),
      ];
}

class _RestaurantsMap extends StatefulWidget {
  const _RestaurantsMap({Key? key}) : super(key: key);

  @override
  State<_RestaurantsMap> createState() => _RestaurantsMapState();
}

class _RestaurantsMapState extends State<_RestaurantsMap> {
  final _currentLocation = const GpsLocation(
      latitude: 41.75, longitude: 12.35); // TODO: Add detect location
  final _queryController = TextEditingController();
  String? _query;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _queryController,
          decoration: InputDecoration(
            label: const Text('Cerca per nome'),
            filled: true,
            prefixIcon: const Icon(Icons.restaurant),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _query = _queryController.text;
                  print('QUERY: $_query');
                });
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ),
        SizedBox(
          height: 500,
          child: FutureBuilder<List<Restaurant>>(
            key: ValueKey(_query),
            future: getIt.get<RestaurantsApi>().getNearRestaurants(
                  _currentLocation,
                  _query,
                ),
            builder: (context, snap) {
              if (snap.hasError) return ErrorWidget(snap.error!);
              if (!snap.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return AppMapboxMap<Restaurant>(
                location: _currentLocation,
                markers: snap.data!
                    .map((e) => e.address.location.toLatLng())
                    .toList(),
                markersData: snap.data!,
                onMarkerTap: (restaurant) {
                  // TODO: Add tap action
                  ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackbar(context: context, content: restaurant.name),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
