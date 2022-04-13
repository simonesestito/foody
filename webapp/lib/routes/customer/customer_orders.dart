import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/orders.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/order_details.dart';

class CustomerOrdersRoute extends BaseRoute {
  static final routeName = UserRole.cliente.routePrefix + '/orders';

  const CustomerOrdersRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) =>
      [
        SliverToBoxAdapter(
          child: Text(
            'Cronologia ordini',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        SliverToBoxAdapter(
          child: FutureBuilder<List<Order>>(
            future: getIt.get<CustomerOrdersApi>().getMyOrders(),
            builder: (context, snap) {
              if (snap.hasError) {
                handleApiError(snap.error!, context);
                return ErrorWidget(snap.error!);
              }

              if (!snap.hasData) {
                return const SizedBox.square(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final order in snap.data!)
                    ListTile(
                      title: Text('#${order.id}'),
                      subtitle: Text(order.creation.toString()),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          OrderDetailsRoute.routeName,
                          arguments: order,
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ];
}
