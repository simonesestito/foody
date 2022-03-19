import 'package:flutter/material.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:foody_app/widgets/card_layout.dart';
import 'package:provider/provider.dart';

import 'form.dart';
import 'user_profile.dart';

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
                ? LoginUserProfile(user: loginStatus.currentUser!)
                : const LoginForm(),
      ),
    );
  }
}
