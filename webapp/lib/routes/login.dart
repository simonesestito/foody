import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/account_logo.dart';
import 'package:foody_app/widgets/bottomsheet.dart';
import 'package:foody_app/widgets/card_layout.dart';
import 'package:provider/provider.dart';

class LoginRoute extends SingleChildBaseRoute {
  static const routeName = '/login';

  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final loginStatus = context.watch<LoginStatus>();
    return SliverToBoxAdapter(
      child: ConstrainedCardLayout(
        child: loginStatus.isLoading
            ? const Center(child: CircularProgressIndicator())
            : loginStatus.isLoggedIn()
                ? _UserProfile(user: loginStatus.currentUser!)
                : const _LoginForm(),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final User user;

  const _UserProfile({required this.user, Key? key}) : super(key: key);

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
          return const _LogoutBottomSheet();
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

class _LogoutBottomSheet extends StatelessWidget {
  const _LogoutBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Globals.minBottomSheetHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Sei sicuro?',
            style: Theme.of(context).textTheme.headline6,
          ),
          const Text('Stai effettuando il logout'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ANNULLA'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: logout vero
                },
                child: const Text('ESCI'),
              ),
            ].withMargin(),
          ),
        ].withMargin(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    return const Text('Login');
  }
}
