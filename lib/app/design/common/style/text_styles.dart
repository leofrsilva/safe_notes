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

  static TextStyle textButton(BuildContext context) => TextStyle(
        fontSize: 18,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      );

  static TextStyle titleFolderList = TextStyle(
    fontSize: 13,
    fontFamily: 'JosefinSans',
    fontWeight: FontWeight.w600,
    color: ColorPalettes.blueGrey,
  );

  // CARDS
  static TextStyle cardTitleFolder = TextStyle(
    fontSize: 12,
    fontFamily: 'JosefinSans',
    fontWeight: FontWeight.w600,
    color: ColorPalettes.blueGrey,
  );

  static TextStyle cardTitleNote = const TextStyle(
    fontSize: 15,
    fontFamily: 'JosefinSans',
    fontWeight: FontWeight.w600,
    // color: ColorPalettes.blueGrey,
  );

  static TextStyle cardDateNote = TextStyle(
    fontSize: 12,
    fontFamily: 'JosefinSans',
    color: ColorPalettes.grey,
  );

  static TextStyle cardBodyNote = TextStyle(
    fontSize: 12,
    fontFamily: 'JosefinSans',
    color: ColorPalettes.blueGrey,
  );
}
