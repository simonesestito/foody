import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';

class CartRoute extends BaseRoute {
  static final routeName = UserRole.customer.routePrefix + '/cart';

  const CartRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [
        SliverToBoxAdapter(
          child: Text(
            'Carrello',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ];
}
