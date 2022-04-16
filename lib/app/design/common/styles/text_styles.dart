import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class TextStyles {
  static TextStyle errorFieldStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'JosefinSans',
    color: ColorPalettes.red,
  );

  static TextStyle fieldStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'JosefinSans',
    color: ColorPalettes.greyDark,
  );

  static TextStyle titleFieldStyle(BuildContext context) => TextStyle(
        fontSize: 15,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      );

  static TextStyle titleError(BuildContext context) => TextStyle(
        fontSize: 15,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
        color: ColorPalettes.grey,
      );
}
