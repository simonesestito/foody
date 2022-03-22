import 'package:flutter/material.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/login/form/mail_form.dart';
import 'package:foody_app/widgets/card_layout.dart';

///
/// Main widget which has an inner custom Navigator
/// to manage the login/signup flows.
///
class LoginFormFlow extends StatelessWidget {
  const LoginFormFlow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Globals.maxFormWidth,
        height: ConstrainedCardLayout.minHeight,
        child: Navigator(
          initialRoute: '/',
          onGenerateInitialRoutes: (_, __) {
            return [
              MaterialPageRoute(
                builder: (_) => LoginMailForm(),
                settings: const RouteSettings(name: '/'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
