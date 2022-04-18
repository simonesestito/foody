import 'package:flutter/material.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/customer_orders.dart';
import 'package:foody_app/routes/customer/leave_review.dart';
import 'package:foody_app/widgets/map.dart';

class OrderDetailsRoute extends SingleChildBaseRoute {
  static final String routeName =
      UserRole.cliente.routePrefix + '/orders/details';

  const OrderDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Order?;

    if (order == null) {
      Future.microtask(() => Navigator.of(context).pushReplacementNamed(
            CustomerOrdersRoute.routeName,
          ));
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ordine #${order.id}',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text('Data: ${order.creation}'),
          Text('Stato: ${order.status.name}'),
          Text('Indirizzo: ${order.address}'),
          const Divider(),
          Text('Prodotti', style: Theme.of(context).textTheme.headline4),
          for (final product in order.orderContent)
            ListTile(
              title: Text(
                '(${product.quantity}x) ${product.product.name} - ${product.product.price.toStringAsFixed(2)}',
              ),
              subtitle: Text(product.product.description ?? ''),
            ),
          if (order.riderService != null)
            AppMapboxMap(
              zoomLocation: order.riderService!.lastLocation,
              onMarkerTap: (_) {},
            ),
          if (order.status == OrderState.delivered)
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  LeaveReviewRoute.routeName,
                  arguments: order.orderContent.first.product.restaurant,
                );
              },
              icon: const Icon(Icons.star),
              label: const Text('Recensisci ristorante'),
            ),
        ],
      ),
    );
  }
}
