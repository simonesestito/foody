import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  static const _logoHeight = 28.0;
  final Color logoColor;

  const Logo({this.logoColor = Colors.white, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/'),
      child: Image.asset(
        'assets/images/logo.png',
        color: logoColor,
        height: _logoHeight,
        colorBlendMode: BlendMode.srcATop,
      ),
    );
  }
}
