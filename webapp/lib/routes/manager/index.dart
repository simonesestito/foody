import 'package:flutter/material.dart';
import 'package:foody_app/data/user.dart';
import 'package:foody_app/routes/base_route.dart';

final managerRoutes = {
  ManagerRoute.routeName: (_) => const ManagerRoute(),
}.map((key, value) => MapEntry(UserRole.manager.routePrefix + key, value));

class ManagerRoute extends SingleChildBaseRoute {
  static const routeName = '';

  const ManagerRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('ManagerRoute'),
      ),
    );
  }
}
