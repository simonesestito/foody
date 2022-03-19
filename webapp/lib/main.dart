import 'package:flutter/material.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/admin/index.dart';
import 'package:foody_app/routes/customer/index.dart';
import 'package:foody_app/routes/home.dart';
import 'package:foody_app/routes/login.dart';
import 'package:foody_app/routes/manager/index.dart';
import 'package:foody_app/routes/rider/index.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FoodyApp());
}

class FoodyApp extends StatelessWidget {
  const FoodyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const dividerTheme = DividerThemeData(
      thickness: 0.07,
      indent: Globals.largeMargin,
      endIndent: Globals.largeMargin,
      space: Globals.largeMargin,
    );

    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
        vertical: Globals.standardMargin,
        horizontal: Globals.standardMargin,
      )),
      minimumSize: MaterialStateProperty.all(const Size(64, 44)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        letterSpacing: 0.65,
        fontWeight: FontWeight.w500,
      )),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(style: buttonStyle);
    final outlinedButtonTheme = OutlinedButtonThemeData(style: buttonStyle);

    const cardTheme = CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Globals.roundedCorner),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginStatus()),
      ],
      builder: (context, child) => child!,
      // child = widgets that don't need direct access to Providers
      child: MaterialApp(
        title: 'Foody App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: const Color(0xff70df4e),
          dividerTheme: dividerTheme,
          elevatedButtonTheme: elevatedButtonTheme,
          outlinedButtonTheme: outlinedButtonTheme,
          cardTheme: cardTheme,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xff70df4e),
          dividerTheme: dividerTheme,
          elevatedButtonTheme: elevatedButtonTheme,
          outlinedButtonTheme: outlinedButtonTheme,
          cardTheme: cardTheme,
        ),
        themeMode: ThemeMode.system,
        initialRoute: Home.routeName,
        routes: {
          Home.routeName: (_) => const Home(),
          LoginRoute.routeName: (_) => const LoginRoute(),
          ...adminRoutes,
          ...customerRoutes,
          ...managerRoutes,
          ...riderRoutes,
        },
      ),
    );
  }
}
