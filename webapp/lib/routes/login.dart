import 'package:flutter/material.dart';
import 'package:foody_app/routes/base_route.dart';

class LoginRoute extends SingleChildBaseRoute {
  static const routeName = '/login';

  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('Login'),
      ),
    );
  }
}
