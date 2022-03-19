import 'package:flutter/material.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class TextTitle extends StatelessWidget {
  final String text;
  Color? color;

  TextTitle({
    Key? key,
    this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Sizes.dp26(context),
          fontFamily: 'JosefinSans',
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
