import 'package:flutter/material.dart';
import 'package:foody_app/routes/base_route.dart';

class LogoutRoute extends SingleChildBaseRoute {
  static const routeName = '/logout';

  const LogoutRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('LogoutRoute'),
      ),
    );
  }
}
