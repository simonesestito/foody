import 'package:flutter/material.dart';
import 'package:foody_app/routes/base_route.dart';

class SignUpRoute extends SingleChildBaseRoute {
  static const routeName = '/signup';

  const SignUpRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('Signup'),
      ),
    );
  }
}
