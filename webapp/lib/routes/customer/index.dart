import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';

final customerRoutes = {
  CustomerRoute.routeName: (_) => const CustomerRoute(),
}.map((key, value) => MapEntry(UserRole.customer.routePrefix + key, value));

class CustomerRoute extends SingleChildBaseRoute {
  static const routeName = '';

  const CustomerRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('CustomerRoute'),
      ),
    );
  }
}
