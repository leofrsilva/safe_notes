import 'package:flutter/material.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class WaveRight extends StatelessWidget {
  Color? color;
  final bool isGradient;
  final double fractionHeight;

  WaveRight({
    Key? key,
    this.color,
    this.isGradient = true,
    required this.fractionHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ClipWaveRight(fractionHeight: fractionHeight),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).primaryColor,
          gradient: isGradient
              ? LinearGradient(
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    ColorPalettes.secondy,
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                )
              : null,
        ),
      ),
    );
  }
}

class ClipWaveRight extends CustomClipper<Path> {
  double? fractionHeight;
  ClipWaveRight({this.fractionHeight});

  @override
  Path getClip(Size size) {
    var path = Path();

    var height = fractionHeight ?? 0.1;

    path.lineTo(0, 0);
    path.lineTo(0, size.height * height);

    path.cubicTo(
      size.width * 0.0,
      size.height * height,
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
      (size.height * height) + (size.height * 0.2),
    );

    path.lineTo(size.width, (size.height * height) + (size.height * 0.2));
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
