import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/users.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/admin/edit_user.dart';
import 'package:foody_app/routes/base_route.dart';

class ListUsersRoute extends SingleChildBaseRoute {
  static final routeName = UserRole.admin.routePrefix + '/users';

  const ListUsersRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return const SliverToBoxAdapter(
      child: _ListUsersContent(),
    );
  }
}

class _ListUsersContent extends StatefulWidget {
  const _ListUsersContent({Key? key}) : super(key: key);

  @override
  State<_ListUsersContent> createState() => _ListUsersContentState();
}

class _ListUsersContentState extends State<_ListUsersContent> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      key: _refreshKey,
      future: getIt.get<UsersApi>().listAll(),
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
              'Elenco utenti',
              style: Theme.of(context).textTheme.headline5,
            ),
            for (final user in snap.data!)
              ListTile(
                title: Text(user.fullName),
                subtitle: Text(user.email),
                leading: const Icon(Icons.person),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    EditUserRoute.routeName,
                    arguments: user,
                  );
                  setState(() {
                    _refreshKey = UniqueKey();
                  });
                },
              ),
          ],
        );
      },
    );
  }
}
