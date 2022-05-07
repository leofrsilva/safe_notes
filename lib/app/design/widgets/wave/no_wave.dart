import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

// ignore: must_be_immutable
class NoWave extends StatelessWidget {
  final bool invertedColor;
  final double fractionHeight;

  late List<Color> gradient;

  NoWave({
    Key? key,
    this.invertedColor = false,
    required this.fractionHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (invertedColor) {
      gradient = <Color>[
        ColorPalettes.secondy,
        Theme.of(context).primaryColor,
      ];
    } else {
      gradient = <Color>[
        Theme.of(context).primaryColor,
        ColorPalettes.secondy,
      ];
    }

    return Container(
      width: Sizes.width(context),
      height: Sizes.height(context) * fractionHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
      ),
    );
  }
}
