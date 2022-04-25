import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/widgets/loading_button.dart';

Future<dynamic> showAppBottomSheet(
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

Future<dynamic> showInputBottomSheet(
    BuildContext context, InputBottomSheet Function(BuildContext) builder) {
  return showAppBottomSheet(context, builder, isScrollControlled: true);
}

class InputBottomSheet extends StatelessWidget {
  final _inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final String title;
  final String label;
  final String saveText;
  final Icon saveIcon;
  final List<String>? autofillHints;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FutureOr<void> Function(String)? onSave;
  final FormFieldValidator<String>? validator;

  InputBottomSheet({
    Key? key,
    required this.title,
    required this.label,
    required this.saveText,
    required this.saveIcon,
    this.onSave,
    this.validator,
    this.keyboardType,
    this.autofillHints,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.headline5),
          TextFormField(
            controller: _inputController,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
            ),
            validator: validator,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            inputFormatters: inputFormatters,
          ),
          LoadingButton(
            label: Text(saveText),
            icon: saveIcon,
            onPressed: () async {
              try {
                if (_formKey.currentState?.validate() != true) return;
                if (onSave != null) {
                  await onSave!(_inputController.text);
                }
                Navigator.pop(context, _inputController.text);
              } catch (err) {
                handleApiError(err, context);
              }
            },
          ),
          Padding(
            padding: MediaQuery.of(context).viewInsets,
          ),
        ],
      ),
    );
  }
}
