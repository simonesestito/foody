import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/order.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/order_details.dart';

class ServiceDetailsRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.rider.routePrefix + '/services/details';

  const ServiceDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as RiderService?;

    if (service == null) {
      Future.microtask(() => Navigator.pop(context));
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: FutureBuilder<List<Order>>(
        future: getIt.get<RiderServiceApi>().getOrdersForService(service.id!),
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
                  onTap: () => Navigator.pushNamed(
                    context,
                    OrderDetailsRoute.routeName,
                    arguments: order,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
