import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataInputFormatter extends TextInputFormatter {
  final String mask = '##/##/####';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String data = newValue.text;
    if (data.length > mask.length) return oldValue;

    data = data.replaceAll(RegExp(r'\D'), '');
    String formatted = mask;

    for (var i = 0; i < data.length; i++) {
      formatted = formatted.replaceFirst('#', data[i]);
    }

    final lastHash = formatted.indexOf('#');
    if (lastHash != -1) {
      formatted = formatted.characters.getRange(0, lastHash).join();
      if (RegExp(r'\D$').hasMatch(formatted)) {
        formatted = formatted.characters
            .getRange(
              0,
              formatted.length - 1,
            )
            .join();
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      ),
    );
  }
}
