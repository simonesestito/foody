import 'package:flutter/material.dart';
import 'package:foody_app/widgets/logo.dart';
import 'package:foody_app/widgets/snackbar.dart';

void main() {
  runApp(const FoodyApp());
}

class FoodyApp extends StatelessWidget {
  const FoodyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const AppLayout(),
    );
  }
}

class AppLayout extends StatelessWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            forceElevated: true,
            expandedHeight: 180,
            flexibleSpace: const FlexibleSpaceBar(
              title: Logo(),
              expandedTitleScale: 2.3,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(AppSnackbar(
                    context: context,
                    content: "TODO",
                    action: SnackBarAction(label: "OK", onPressed: () {}),
                  ));
                },
                icon: const Icon(Icons.account_circle),
                tooltip: "Account",
              ),
            ],
          ),
          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.all(8),
            child: OutlinedButton(
              child: const Text("Test"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(AppSnackbar(
                  context: context,
                  content: "Test n.2",
                  action: SnackBarAction(label: "NO", onPressed: () {}),
                ));
              },
            ),
          )),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              List.generate(
                200,
                (_) => ListTile(title: Text("Ciao")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
