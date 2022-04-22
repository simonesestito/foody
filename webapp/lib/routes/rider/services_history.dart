import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/rider_service.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/rider/show_service.dart';

class ServicesHistoryRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.rider.routePrefix + '/services';

  const ServicesHistoryRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<RiderService>>(
        future: getIt.get<RiderServiceApi>().getAllPast(),
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
              for (final service in snap.data!)
                ListTile(
                  title: Text(service.start.toString()),
                  subtitle: Text('Terminato il ${service.end?.toString()}'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    ServiceDetailsRoute.routeName,
                    arguments: service,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
