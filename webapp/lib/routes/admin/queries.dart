import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/query_stats.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';

class StatQueriesRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.admin.routePrefix + '/queries';

  const StatQueriesRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
        child: FutureBuilder<Map<String, dynamic>>(
      future: getIt.get<QueryStatsApi>().getAll(),
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
            Text(
              'Query per le statistiche',
              style: Theme.of(context).textTheme.headline5,
            ),
            for (final queryResult in snap.data!.entries.toList().reversed) ...[
              Text(
                'Query ${queryResult.key}',
                style: Theme.of(context).textTheme.headline6,
              ),
              if (queryResult.value is List)
                ..._buildList(queryResult.value)
              else
                ..._buildMap(queryResult.value)
            ]
          ],
        );
      },
    ));
  }

  List<Widget> _buildList(List values) => [
        for (final row in values)
          ListTile(
            leading: const Icon(Icons.keyboard_arrow_right),
            subtitle: Text(
                row.entries.map((e) => '${e.key} = ${e.value}').join('\n')),
          ),
      ];

  List<Widget> _buildMap(Map valuesMap) {
    final idName = valuesMap['-1']?.first['_key'].toString();
    return [
      for (final row
          in valuesMap.entries.where((e) => int.parse(e.key) >= 0)) ...[
        Text('Elemento con $idName = ${row.key}'),
        ..._buildList(row.value),
      ]
    ];
  }
}
