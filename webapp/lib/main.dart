import 'package:flutter/material.dart';
import 'package:foody_app/appbar.dart';

void main() {
  runApp(const FoodyApp());
}

class FoodyApp extends StatelessWidget {
  const FoodyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foody App',
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
      appBar: const Appbar(),
      body: const Center(child: Text("Ciao")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Non toccare, terrun!")),
        ),
        label: const Text("Test"),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
