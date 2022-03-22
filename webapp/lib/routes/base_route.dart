import 'package:flutter/material.dart';
import 'package:foody_app/widgets/account_logo.dart';
import 'package:foody_app/widgets/footer.dart';
import 'package:foody_app/widgets/logo.dart';

/// Base route widget
abstract class BaseRoute extends StatelessWidget {
  const BaseRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            forceElevated: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              title: Logo(),
              expandedTitleScale: 2.3,
            ),
            actions: [AccountLogo()],
          ),
          ...buildChildren(context),
          const AppFooter(),
        ],
      ),
    );
  }

  /// Build Sliver children
  List<Widget> buildChildren(BuildContext context);
}

abstract class SingleChildBaseRoute extends BaseRoute {
  const SingleChildBaseRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [buildChild(context)];

  /// Build single Sliver child
  Widget buildChild(BuildContext context);
}
