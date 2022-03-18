import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final Color logoColor;

  const Logo({this.logoColor = Colors.white, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      color: logoColor,
      height: 28,
      colorBlendMode: BlendMode.srcATop,
    );
  }
}
