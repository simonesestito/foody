import 'package:flutter/material.dart';
import 'package:foody_app/globals.dart';

Future<void> showAppBottomSheet(
  BuildContext context,
  WidgetBuilder builder, {
  bool isScrollControlled = false,
}) async {
  return showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    context: context,
    constraints: const BoxConstraints(
      minHeight: Globals.minBottomSheetHeight,
      maxWidth: Globals.maxBottomSheetWidth,
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _BottomSheetPicker(),
          Padding(
            padding: const EdgeInsets.all(Globals.largeMargin),
            child: builder(context),
          ),
        ],
      );
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Globals.roundedCorner,
        topRight: Globals.roundedCorner,
      ),
    ),
  );
}

class _BottomSheetPicker extends StatelessWidget {
  static const _height = 6.0;
  static const _width = _height * 6;
  static const _radius = _height / 2;

  const _BottomSheetPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground.withAlpha(100),
        borderRadius: const BorderRadius.all(Radius.circular(_radius)),
      ),
      margin: const EdgeInsets.only(top: Globals.smallMargin),
    );
  }
}
