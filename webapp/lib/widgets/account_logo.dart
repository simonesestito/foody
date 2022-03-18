import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/login.dart';
import 'package:foody_app/routes/logout.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:provider/provider.dart';

class AccountLogo extends StatelessWidget {
  static const _iconSize = 38.0;

  const AccountLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<LoginStatus>().isLoading) {
      return Padding(
        padding: const EdgeInsets.all(Globals.standardMargin),
        child: AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryTextTheme.bodyText1!.color,
          ),
        ),
      );
    }

    return PopupMenuButton<String?>(
        icon: const Icon(Icons.account_circle),
        iconSize: _iconSize,
        tooltip: 'Account',
        onSelected: (route) {
          if (route != null) Navigator.of(context).pushNamed(route);
        },
        itemBuilder: (context) {
          LoginStatus loginStatus = context.read();
          if (loginStatus.isLoggedIn()) {
            return _buildLoginUserMenu(context, loginStatus.currentUser!);
          } else {
            return _buildLoggedOutUserMenu(context);
          }
        });
  }

  List<PopupMenuEntry<String?>> _buildLoggedOutUserMenu(BuildContext context) =>
      [
        const PopupMenuItem(
          value: LoginRoute.routeName,
          child: ListTile(
            mouseCursor: SystemMouseCursors.click,
            title: Text('Login'),
            leading: Icon(Icons.login),
          ),
        ),
      ];

  List<PopupMenuEntry<String?>> _buildLoginUserMenu(
      BuildContext context, User user) {
    List<PopupMenuEntry<String?>> menu = [
      PopupMenuItem(
        enabled: false,
        child: ListTile(
          title: Text(user.fullName),
          subtitle: Text(user.email),
          leading: const Icon(Icons.account_box_rounded),
        ),
      ),
      const PopupMenuItem(
        value: LogoutRoute.routeName,
        child: ListTile(
          mouseCursor: SystemMouseCursors.click,
          title: Text('Logout'),
          leading: Icon(Icons.logout),
        ),
      ),
    ];

    if (user.allowedRoles.length > 1) {
      menu.addAll([
        const PopupMenuDivider(),
        const PopupMenuItem(
          enabled: false,
          child: Text(
            'Accedi come...',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ]);

      for (final role in user.allowedRoles) {
        menu.add(PopupMenuItem(
          value: role.routePrefix,
          child: ListTile(
            mouseCursor: SystemMouseCursors.click,
            title: Text(role.displayName),
            leading: Icon(role.icon),
          ),
        ));
      }
    }

    return menu;
  }
}
