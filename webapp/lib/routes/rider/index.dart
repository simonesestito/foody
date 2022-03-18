import 'package:flutter/material.dart';
import 'package:foody_app/data/user.dart';
import 'package:foody_app/routes/base_route.dart';

final riderRoutes = {
  RiderRoute.routeName: (_) => const RiderRoute(),
}.map((key, value) => MapEntry(UserRole.rider.routePrefix + key, value));

class RiderRoute extends SingleChildBaseRoute {
  static const routeName = '';

  const RiderRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('RiderRoute'),
      ),
    );
  }
}
