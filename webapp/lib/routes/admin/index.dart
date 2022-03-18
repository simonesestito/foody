import 'package:flutter/material.dart';
import 'package:foody_app/data/user.dart';
import 'package:foody_app/routes/base_route.dart';

final adminRoutes = {
  AdminRoute.routeName: (_) => const AdminRoute(),
}.map((key, value) => MapEntry(UserRole.admin.routePrefix + key, value));

class AdminRoute extends SingleChildBaseRoute {
  static const routeName = '';

  const AdminRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('AdminRoute'),
      ),
    );
  }
}
