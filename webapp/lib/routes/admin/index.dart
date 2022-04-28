import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/admin/edit_restaurant.dart';
import 'package:foody_app/routes/admin/edit_user.dart';
import 'package:foody_app/routes/admin/list_restaurants.dart';
import 'package:foody_app/routes/admin/list_users.dart';
import 'package:foody_app/routes/admin/queries.dart';
import 'package:foody_app/routes/base_route.dart';

final adminRoutes = {
  AdminRoute.routeName: (_) => const AdminRoute(),
  ListUsersRoute.routeName: (_) => const ListUsersRoute(),
  EditUserRoute.routeName: (_) => const EditUserRoute(),
  ListRestaurantsRoute.routeName: (_) => const ListRestaurantsRoute(),
  EditRestaurantRoute.routeName: (_) => const EditRestaurantRoute(),
  StatQueriesRoute.routeName: (_) => const StatQueriesRoute(),
};

class AdminRoute extends BaseRoute {
  static final routeName = UserRole.admin.routePrefix;

  const AdminRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            ListUsersRoute.routeName,
          ),
          icon: const Icon(Icons.supervised_user_circle),
          label: const Text('Gestisci utenti'),
        ),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            ListRestaurantsRoute.routeName,
          ),
          icon: const Icon(Icons.restaurant),
          label: const Text('Gestisci ristoranti'),
        ),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            StatQueriesRoute.routeName,
          ),
          icon: const Icon(Icons.query_stats),
          label: const Text('Vedi query di statistiche'),
        ),
      ]
          .map((e) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: e,
                ),
              ))
          .toList();
}
