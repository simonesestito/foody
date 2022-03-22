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

FormFieldValidator fieldValidator({bool Function(String)? then}) => (value) {
      if (value == null) return 'Campo mancante';
      if (value.length <= 3) return 'Campo troppo corto';
      if (value.length >= 255) return 'Campo troppo lungo';
      if (then?.call(value) == false) return 'Valore inserito errato';
      return null;
    };

bool phoneValidator(String value) {
  if (!value.startsWith('+')) {
    value = '+39$value';
  }

  const phoneNumberRegex =
      r'^\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$';
  return RegExp(phoneNumberRegex).hasMatch(value);
}
