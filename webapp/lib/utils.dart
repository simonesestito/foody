import 'package:flutter/material.dart';
import 'package:foody_app/globals.dart';

extension ListUtils on List<Widget> {
  List<Widget> withMargin({double margin = Globals.standardMargin}) {
    return List.generate(
      2 * length - 1,
      (index) => index % 2 == 0
          ? this[index ~/ 2]
          : SizedBox.square(dimension: margin),
    );
  }
}
