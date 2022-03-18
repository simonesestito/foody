import 'package:flutter/material.dart';
import 'package:foody_app/widgets/logo.dart';

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("TODO")),
                  );
                },
                icon: const Icon(Icons.account_circle),
                tooltip: "Account",
              ),
            ],
          ),
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
