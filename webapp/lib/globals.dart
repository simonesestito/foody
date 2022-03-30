import 'package:flutter/material.dart';

class Globals {
  Globals._();

  static const smallMargin = 12.0;
  static const standardMargin = 16.0;
  static const largeMargin = 24.0;

  static const mapboxAccessToken =
      'pk.eyJ1Ijoic2ltb25lLXNlc3RpdG8iLCJhIjoiY2s5b251NzQwMDJoNzNlbnhkOXRtMGRyZSJ9.JPvm9gLEdOvsFgROr36-NQ';

  static const containerConstraints = BoxConstraints(
    maxWidth: 600.0,
  );

  static const minBottomSheetHeight = 180.0;
  static const maxBottomSheetWidth = 600.0;
  static const maxFormWidth = 350.0;
  static const roundedCorner = Radius.circular(12.0);
}
