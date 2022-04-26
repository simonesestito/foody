import 'package:flutter/material.dart';
import 'package:foody_app/data/api/admin_restaurants.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/admin/edit_restaurant.dart';
import 'package:foody_app/routes/base_route.dart';

class ListRestaurantsRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.admin.routePrefix + '/restaurants';

  const ListRestaurantsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: _ListRestaurantsContent(),
    );
  }
}

class _ListRestaurantsContent extends StatefulWidget {
  const _ListRestaurantsContent({Key? key}) : super(key: key);

  @override
  State<_ListRestaurantsContent> createState() =>
      _ListRestaurantsContentState();
}

class _ListRestaurantsContentState extends State<_ListRestaurantsContent> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RestaurantWithMenu>>(
      key: _refreshKey,
      future: getIt.get<AdminRestaurantsApi>().getAll(),
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
            Text(
              'Elenco ristoranti',
              style: Theme.of(context).textTheme.headline5,
            ),
            OutlinedButton.icon(
              onPressed: () async {
                final mustRefresh = await Navigator.pushNamed(
                  context,
                  EditRestaurantRoute.routeName,
                );
                if (mustRefresh == true) {
                  setState(() {
                    _refreshKey = UniqueKey();
                  });
                }
              },
              icon: const Icon(Icons.restaurant),
              label: const Text('Aggiungi nuovo'),
            ),
            for (final restaurant in snap.data!)
              ListTile(
                title: Text(restaurant.name),
                subtitle: Text(restaurant.address.toString()),
                leading: const Icon(Icons.restaurant),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    EditRestaurantRoute.routeName,
                    arguments: restaurant,
                  );setState(() {
                      _refreshKey = UniqueKey();
                    });
                },
              ),
          ],
        );
      },
    );
  }
}
