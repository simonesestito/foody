import 'package:flutter/material.dart';
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/rider/pick_order.dart';
import 'package:foody_app/routes/rider/services_history.dart';
import 'package:foody_app/routes/rider/show_service.dart';
import 'package:foody_app/routes/rider/start_service.dart';

final riderRoutes = {
  RiderRoute.routeName: (_) => const RiderRoute(),
  PickRiderOrderRoute.routeName: (_) => const PickRiderOrderRoute(),
  ServicesHistoryRoute.routeName: (_) => const ServicesHistoryRoute(),
  ServiceDetailsRoute.routeName: (_) => const ServiceDetailsRoute(),
  StartServiceRoute.routeName: (_) => const StartServiceRoute(),
};

class RiderRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.rider.routePrefix;

  const RiderRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(child: _RiderConditionalRoute());
  }
}

class _RiderConditionalRoute extends StatefulWidget {
  const _RiderConditionalRoute({Key? key}) : super(key: key);

  @override
  State<_RiderConditionalRoute> createState() => _RiderConditionalRouteState();
}

class _RiderConditionalRouteState extends State<_RiderConditionalRoute> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RiderService?>(
        key: _refreshKey,
        future: getIt.get<RiderServiceApi>().getActiveService(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            final nextRoute = snap.data == null
                ? StartServiceRoute.routeName
                : PickRiderOrderRoute.routeName;
            final replacement = snap.data != null;

            Future.microtask(() async {
              if (mounted) {
                if (replacement) {
                  Navigator.pushReplacementNamed(context, nextRoute);
                } else {
                  await Navigator.pushNamed(context, nextRoute);

                  setState(() {
                    _refreshKey = UniqueKey();
                  });
                }
              }
            });
          }

          return const SizedBox.square(
            dimension: 36,
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
