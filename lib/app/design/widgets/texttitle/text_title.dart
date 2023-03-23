import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextTitle extends StatelessWidget {
  final String text;
  double? size;
  Color? color;
  final Gradient? gradient;
  FontWeight? fontWeight;

  TextTitle({
    Key? key,
    this.size,
    this.color,
    this.gradient,
    this.fontWeight,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size ?? 22,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
      ),
    );
    if (gradient == null) {
      return textWidget;
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient!.createShader(
        Rect.fromLTWH(-20, -20, bounds.width, bounds.height),
      ),
      child: textWidget,
    );
  }
}
