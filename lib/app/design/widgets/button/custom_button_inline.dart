import 'package:flutter/material.dart';

class CustomButtonInline extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const CustomButtonInline({
    Key? key,
    this.onTap,
    required this.text,
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
          decoration: TextDecoration.underline,
        ),
      ),
      onPressed: onTap,
    );
  }
}
