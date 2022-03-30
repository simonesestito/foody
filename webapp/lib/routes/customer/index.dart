import 'package:flutter/material.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/customer_orders.dart';
import 'package:foody_app/routes/customer/restaurant_details.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/map.dart';
import 'package:foody_app/widgets/snackbar.dart';

final customerRoutes = {
  CustomerRoute.routeName: (_) => const CustomerRoute(),
  CustomerOrdersRoute.routeName: (_) => const CustomerOrdersRoute(),
  RestaurantDetailsRoute.routeName: (_) => const RestaurantDetailsRoute(),
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
        const SliverToBoxAdapter(child: _RestaurantsMap()),
      ];
}

class _RestaurantsMap extends StatefulWidget {
  const _RestaurantsMap({Key? key}) : super(key: key);

  @override
  State<_RestaurantsMap> createState() => _RestaurantsMapState();
}

class _RestaurantsMapState extends State<_RestaurantsMap> {
  final _queryController = TextEditingController();
  GpsLocation? _currentLocation;
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
              onPressed: _onSubmitSearch,
              icon: const Icon(Icons.search),
            ),
          ),
          onFieldSubmitted: _onSubmitSearch,
        ),
        SizedBox(
          height: 500,
          child: FutureBuilder<List<Restaurant>>(
            key: ValueKey(_query),
            future: _loadNearRestaurants(),
            builder: (context, snap) {
              if (snap.hasError) return ErrorWidget(snap.error!);
              if (!snap.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final GpsLocation location;
              if (snap.data!.isEmpty) {
                location = _currentLocation!;
                Future.microtask(
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackbar(content: 'Nessun risultato', context: context),
                  ),
                );
              } else {
                location = snap.data!.first.address.location;
              }

              return AppMapboxMap<Restaurant>(
                zoomLocation: location,
                markers: snap.data!
                    .map((e) => e.address.location.toLatLng())
                    .toList(),
                markersData: snap.data!,
                userLocation: _currentLocation!,
                onMarkerTap: (restaurant) {
                  Navigator.pushNamed(context, RestaurantDetailsRoute.routeName,
                      arguments: restaurant);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSubmitSearch([String? _]) {
    setState(() {
      _query = _queryController.text;
    });
  }

  Future<List<Restaurant>> _loadNearRestaurants() async {
    _currentLocation = await getUserGpsLocation();
    return getIt.get<RestaurantsApi>().getNearRestaurants(
          GpsLocation(
            latitude: _currentLocation!.latitude,
            longitude: _currentLocation!.longitude,
          ),
          _query,
        );
  }
}
