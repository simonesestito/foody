import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/rider_service.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/rider/services_history.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class StartServiceRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.rider.routePrefix + '/start';

  const StartServiceRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        LoadingButton(
          onPressed: () async {
            try {
              await getIt.get<RiderServiceApi>().startService(
                    await getUserGpsLocation(),
                  );
              Navigator.pop(context);
            } catch (err) {
              handleApiError(err, context);
            }
          },
          icon: const Icon(Icons.bike_scooter),
          label: const Text('Avvia nuovo servizio'),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            ServicesHistoryRoute.routeName,
          ),
          icon: const Icon(Icons.timeline),
          label: const Text('Storico servizi'),
        ),
      ]),
    );
  }
}
