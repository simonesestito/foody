import 'package:flutter/material.dart';
import 'package:foody_app/globals.dart';

///
/// Card constrained to be the main layout
///
class ConstrainedCardLayout extends StatelessWidget {
  static const minWidth = 500.0;
  static const maxWidth = 600.0;
  static const minHeight = 400.0;

  static const defaultCardConstraints = BoxConstraints(
    minWidth: minWidth,
    maxWidth: maxWidth,
    minHeight: minHeight,
  );

  final BoxConstraints cardConstraints;
  final Widget child;

  const ConstrainedCardLayout({
    this.cardConstraints = defaultCardConstraints,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Globals.largeMargin),
      child: ConstrainedBox(
        constraints: cardConstraints,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Globals.standardMargin),
            child: child,
          ),
        ),
      ),
    );
  }
}
