import 'package:flutter/material.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/login.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:provider/provider.dart';

class AccountLogo extends StatelessWidget {
  static const iconSize = 38.0;

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

    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed(LoginRoute.routeName),
      icon: const Icon(Icons.account_circle),
      tooltip: 'Account',
      iconSize: iconSize,
    );
  }
}
