import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/orders.dart';
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/order_details.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class PickRiderOrderRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.rider.routePrefix + '/orders';

  const PickRiderOrderRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Scegli ordine', style: Theme.of(context).textTheme.headline5),
          const _OrdersContent(),
        ],
      ),
    );
  }
}

class _OrdersContent extends StatefulWidget {
  const _OrdersContent({Key? key}) : super(key: key);

  @override
  State<_OrdersContent> createState() => _OrdersContentState();
}

class _OrdersContentState extends State<_OrdersContent> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _refreshKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingButton(
          onPressed: () async {
            await getIt.get<RiderServiceApi>().endService();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Termina servizio'),
        ),
        Text(
          'Ordine in consegna',
          style: Theme.of(context).textTheme.headline6,
        ),
        FutureBuilder<Order?>(
          future: getIt.get<RiderServiceApi>().getDeliveringOrder(),
          builder: (context, snap) {
            if (snap.hasError) {
              handleApiError(snap.error!, context);
              return ErrorWidget(snap.error!);
            }

            if (snap.connectionState == ConnectionState.active) {
              return const SizedBox.square(
                dimension: 36,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snap.hasData) {
              return ListTile(
                title: Text(snap.data!.restaurant.name),
                subtitle: Text('${snap.data!.orderContent.length} prodotti'),
                onTap: () => _onOrderPicked(context, snap.data!),
              );
            } else {
              return const Text('Nessun ordine in consegna');
            }
          },
        ),
        Text(
          'Ordini selezionabili',
          style: Theme.of(context).textTheme.headline6,
        ),
        FutureBuilder<List<Order>>(
            future: _loadNearOrders(),
            builder: (context, snap) {
              if (snap.hasError) {
                handleApiError(snap.error!, context);
                return ErrorWidget(snap.error!);
              }

              if (!snap.hasData) {
                return const SizedBox.square(
                  dimension: 36,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final order in snap.data!)
                    ListTile(
                      title: Text(order.restaurant.name),
                      subtitle: Text('${order.orderContent.length} prodotti'),
                      onTap: () => _onOrderPicked(context, order),
                    ),
                ],
              );
            }),
      ],
    );
  }

  Future<List<Order>> _loadNearOrders() async {
    final location = await getUserGpsLocation();
    return getIt.get<CustomerOrdersApi>().getNearPreparedOrders(location);
  }

  Future<void> _onOrderPicked(BuildContext context, Order order) async {
    await Navigator.pushNamed(
      context,
      OrderDetailsRoute.routeName,
      arguments: order,
    );

    setState(() {
      _refreshKey = UniqueKey();
    });
  }
}
