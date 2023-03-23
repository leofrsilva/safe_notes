import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonInline extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool underline;

  const CustomButtonInline({
    Key? key,
    this.onTap,
    required this.text,
    this.underline = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          decoration: underline ? TextDecoration.underline : null,
          decorationStyle: TextDecorationStyle.solid,
          decorationColor: Theme.of(context).colorScheme.primary,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
