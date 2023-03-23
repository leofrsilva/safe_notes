import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle errorFieldStyle(BuildContext context) => TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.error,
      );

  static TextStyle fieldStyle(BuildContext context) => TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.inverseSurface,
      );

  static TextStyle titleFieldStyle(BuildContext context) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle textButton(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle titleFolderList(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
      );

  // CARDS
  static TextStyle cardTitleFolder(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle cardBodyNote(BuildContext context) => TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle cardTitleNote(BuildContext context) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.tertiary,
      );

  static TextStyle cardDateNote = const TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
}
