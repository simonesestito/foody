import 'package:flutter/material.dart';
import 'package:foody_app/routes/admin/index.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/index.dart';
import 'package:foody_app/routes/manager/index.dart';
import 'package:foody_app/routes/rider/index.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:foody_app/widgets/snackbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FoodyApp());
}

class FoodyApp extends StatelessWidget {
  const FoodyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xff70df4e),
        ),
        themeMode: ThemeMode.system,
        initialRoute: Home.routeName,
        routes: {
          Home.routeName: (_) => const Home(),
          ...adminRoutes,
          ...customerRoutes,
          ...managerRoutes,
          ...riderRoutes,
        },
      ),
    );
  }
}

class Home extends BaseRoute {
  static const routeName = '/';

  const Home({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      SliverToBoxAdapter(
          child: Container(
        padding: const EdgeInsets.all(8),
        child: OutlinedButton(
          child: const Text('Test'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(AppSnackbar(
              context: context,
              content: 'Test n.2',
              action: SnackBarAction(label: 'NO', onPressed: () {}),
            ));
          },
        ),
      )),
      SliverList(
        delegate: SliverChildListDelegate.fixed(
          List.generate(
            200,
            (_) => const ListTile(title: Text('Ciao')),
          ),
        ),
      ),
    ];
  }
}
