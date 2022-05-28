import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/style/styles.dart';
import 'package:safe_notes/app/design/common/util/utils.dart';

import 'text_overflow_field.dart';

class CustomTextFieldTitleNote extends StatelessWidget {
  const CustomTextFieldTitleNote({
    Key? key,
    required this.isFavorite,
    required this.expanded,
    this.childDetails,
    this.onChanged,
    this.onTapIcon,
    this.onTapFavorite,
    this.turnsColor,
    this.onTapTextField,
    this.heightExpanded = 135,
    this.heightNotExpanded = 50,
    required this.controller,
    this.initialFocus = true,
    this.turnsCurve = Curves.easeIn,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final bool initialFocus;
  final TextEditingController controller;

  final bool expanded;
  final bool isFavorite;
  final Widget? childDetails;

  final double heightExpanded;
  final double heightNotExpanded;

  final Duration duration;
  final Color? turnsColor;
  final Curve turnsCurve;

  final Function()? onTapIcon;
  final Function()? onTapFavorite;
  final Function()? onTapTextField;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    Widget details = childDetails ?? Container();
    double top = (heightNotExpanded - (heightNotExpanded * 0.7)) / 2;

    return AnimatedContainer(
      curve: turnsCurve,
      duration: duration,
      height: expanded ? heightExpanded : heightNotExpanded,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: ColorPalettes.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: expanded ? 1.0 : 0.0,
            duration: duration,
            child: Align(
              alignment: Alignment.topRight,
              child: iconFavorite(),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: iconArrow(context),
          ),
          AnimatedPositioned(
            duration: duration,
            top: expanded ? 45 : top,
            left: expanded ? 25.0 : 50.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: duration,
                  curve: turnsCurve,
                  transform: Matrix4.translationValues(0, 0, 0)
                    ..scale(expanded ? 1.0 : 0.7),
                  height: heightNotExpanded,
                  width: Sizes.width(context) - (50.0 / 2),
                  alignment: Alignment.center,
                  child: _textField,
                ),
                AnimatedOpacity(
                  opacity: expanded ? 1.0 : 0.0,
                  duration: duration,
                  child: details,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconFavorite() {
    return IconButton(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      icon: Icon(
        isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
        color: isFavorite ? ColorPalettes.yellow : ColorPalettes.grey,
        size: 30,
      ),
      onPressed: onTapFavorite,
    );
  }

  Widget iconArrow(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      icon: AnimatedRotation(
        turns: expanded ? 0.25 : 0.0,
        duration: duration,
        child: Icon(
          Icons.keyboard_arrow_left,
          color: turnsColor ?? Theme.of(context).primaryColor,
          size: 32,
        ),
      ),
      onPressed: onTapIcon,
    );
  }

  Widget get _textField {
    return TextOverflowField(
      canRequestFocus: initialFocus,
      height: heightNotExpanded,
      controller: controller,
      spaceTop: 4.0,
      spaceLeft: 0.0,
      spaceRight: 12,
      onTapTextField: onTapTextField,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 24,
        // height: expanded ? null : 3.5,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
        color: ColorPalettes.blueGrey,
      ),
      hintText: 'Título',
      hintStyle: TextStyle(
        fontSize: 24,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
        color: ColorPalettes.grey.withOpacity(0.2),
      ),
      border: InputBorder.none,
    );
  }
}
