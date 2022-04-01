import 'package:flutter/material.dart';
import 'package:foody_app/data/api/auth.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/data/model/user_session.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/widgets/account_logo.dart';
import 'package:foody_app/widgets/bottom_sheet.dart';

import 'logout.dart';

class LoginUserProfile extends StatelessWidget {
  final User user;

  const LoginUserProfile({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _Profile(user),
      const Divider(),
      const _LogoutButton(),
      const Divider(),
      _UserRoles(user),
      const Divider(),
      const _UserSessions(),
    ]);
  }
}

class _Profile extends StatelessWidget {
  final User user;

  const _Profile(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hai effettuato l\'accesso come:',
          style: Theme.of(context).textTheme.headline6,
        ),
        ListTile(
          title: Text(user.fullName),
          subtitle: Text(user.email),
          leading: const Icon(
            Icons.account_box_rounded,
            size: AccountLogo.iconSize,
          ),
        )
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Logout'),
      leading: const Icon(Icons.logout),
      onTap: () => showAppBottomSheet(context, (context) {
        return const LogoutBottomSheet();
      }),
    );
  }
}

class _UserRoles extends StatelessWidget {
  final User user;

  const _UserRoles(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Accedi come...',
          style: Theme.of(context).textTheme.headline6,
        ),
        for (final role in user.allowedRoles)
          ListTile(
            title: Text(role.displayName),
            leading: Icon(role.icon),
            onTap: () => Navigator.of(context).pushNamed(role.routePrefix),
          ),
      ],
    );
  }
}

class _UserSessions extends StatefulWidget {
  const _UserSessions({Key? key}) : super(key: key);

  @override
  State<_UserSessions> createState() => _UserSessionsState();
}

class _UserSessionsState extends State<_UserSessions> {
  bool _loading = false;
  List<UserSession> _sessions = [];

  void _refreshSessions() async {
    setState(() {
      _loading = true;
    });

    _sessions = await getIt.get<AuthApi>().getSessions();

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _refreshSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const CircularProgressIndicator();

    return Column(children: [
      Text(
        'Sessioni attive',
        style: Theme.of(context).textTheme.headline6,
      ),
      for (final session in _sessions)
        ListTile(
          leading: session.isCurrent
              ? const Tooltip(
                  child: Icon(Icons.admin_panel_settings),
                  message: 'Sessione corrente',
                )
              : const Icon(Icons.key),
          title: Tooltip(
            child: Text(session.lastIpAddress),
            message: session.userAgent,
          ),
          subtitle: Text(
            'Creato: ${session.creationDate}\nUltimo utilizzo: ${session.lastUsageDate}',
          ),
          isThreeLine: true,
          trailing: session.isCurrent
              ? null
              : IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Revoca sessione di login',
                  onPressed: () async {
                    await getIt.get<AuthApi>().logout(session.token).catchError(
                          (err) => handleApiError(err, context),
                        );
                    _refreshSessions();
                  },
                ),
        ),
    ]);
  }
}
