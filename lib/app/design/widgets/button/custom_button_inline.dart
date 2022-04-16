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
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'JosefinSans',
          color: Theme.of(context).primaryColor,
          decoration: underline ? TextDecoration.underline : null,
        ),
      ),
      onPressed: onTap,
    );
  }
}
