import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/widgets/account_logo.dart';
import 'package:foody_app/widgets/bottomsheet.dart';

import 'logout.dart';

class LoginUserProfile extends StatelessWidget {
  final User user;

  const LoginUserProfile({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
      ),
      const Divider(),
      ListTile(
        title: const Text('Logout'),
        leading: const Icon(Icons.logout),
        onTap: () => showAppBottomSheet(context, (context) {
          return const LogoutBottomSheet();
        }),
      ),
      const Divider(),
      Text(
        'Accedi come...',
        style: Theme.of(context).textTheme.headline6,
      ),
      const SizedBox.square(dimension: Globals.standardMargin),
      for (final role in user.allowedRoles)
        ListTile(
          title: Text(role.displayName),
          leading: Icon(role.icon),
          onTap: () => Navigator.of(context).pushNamed(role.routePrefix),
        ),
    ]);
  }
}
