import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';

class CustomerOrdersRoute extends BaseRoute {
  static final routeName = UserRole.customer.routePrefix + '/orders';

  const CustomerOrdersRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [
        SliverToBoxAdapter(
          child: Text(
            'Cronologia ordini',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ];
}
