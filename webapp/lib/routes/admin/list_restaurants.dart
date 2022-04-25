import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';

class ListRestaurantsRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.admin.routePrefix + '/restaurants';

  const ListRestaurantsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    // TODO: implement buildChild
    throw UnimplementedError();
  }
}
