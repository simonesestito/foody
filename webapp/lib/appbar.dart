import 'package:flutter/material.dart';

class Appbar extends PreferredSize {
  const Appbar({Key? key})
      : super(
          key: key,
          child: const _Appbar(),
          preferredSize: _Appbar.preferredSize,
        );
}

class _Appbar extends StatelessWidget {
  static const Size preferredSize = Size(double.infinity, 64);

  const _Appbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.headline5;
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Foody",
                style: titleStyle,
              ),
            ),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Account",
                style: titleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
