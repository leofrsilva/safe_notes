import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WaveLeft extends StatelessWidget {
  Color? color;
  final bool isGradient;
  final double fractionHeight;
  final bool invertedColor;
  late List<Color> gradient;

  WaveLeft({
    Key? key,
    this.color,
    this.isGradient = true,
    this.invertedColor = false,
    required this.fractionHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (invertedColor) {
      gradient = <Color>[
        Theme.of(context).colorScheme.tertiary,
        Theme.of(context).colorScheme.primary,
      ];
    } else {
      gradient = <Color>[
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.tertiary,
      ];
    }

    return ClipPath(
      clipper: ClipWaveLeft(fractionHeight: fractionHeight),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary,
          gradient: isGradient
              ? LinearGradient(
                  colors: gradient,
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                )
              : null,
        ),
      ),
    );
  }
}

class ClipWaveLeft extends CustomClipper<Path> {
  double? fractionHeight;
  ClipWaveLeft({this.fractionHeight});

  @override
  Path getClip(Size size) {
    var path = Path();

    double height = fractionHeight ?? 0.1;

    path.lineTo(0, 0);
    path.lineTo(0, (size.height * height) + (size.height * 0.3));

    path.cubicTo(
      size.width * 0.0,
      (size.height * height) + (size.height * 0.3),
      size.width * 0.05,
      (size.height * height) + (size.height * 0.1),
      size.width * 0.3,
      (size.height * height) + (size.height * 0.1),
    );

    path.lineTo(size.width * 0.7, (size.height * height) + (size.height * 0.1));

    path.cubicTo(
      size.width * 0.7,
      (size.height * height) + (size.height * 0.1),
      size.width * 0.95,
      (size.height * height) + (size.height * 0.1),
      size.width,
      (size.height * height) - (size.height * 0.1),
    );

    // path.lineTo(
    //   size.width,
    //   (size.height * height) - (size.height * 0.1),
    // );
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
