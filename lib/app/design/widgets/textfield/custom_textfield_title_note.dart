import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/style/styles.dart';
import 'package:safe_notes/app/design/common/util/utils.dart';

class CustomTextFieldTitleNote extends StatelessWidget {
  const CustomTextFieldTitleNote({
    Key? key,
    required this.expanded,
    this.childDetails,
    this.onChanged,
    this.onTapIcon,
    this.onTapFavorite,
    this.onTapTextField,
    this.heightExpanded = 135,
    this.heightNotExpanded = 50,
    this.turnsColor,
    this.turnsCurve = Curves.easeIn,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final bool expanded;
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
                  width: Sizes.width(context),
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
      icon: const Icon(
        Icons.star_outline_rounded,
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
    return TextField(
      onTap: onTapTextField,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 24,
        // height: expanded ? null : 3.5,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
        color: ColorPalettes.blueGrey,
      ),
      // cursorHeight: 25.0,
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.amber,
        // contentPadding: expanded
        //     ? const EdgeInsets.only(
        //         bottom: 15,
        //       )
        //     : const EdgeInsets.only(
        //         bottom: 19.0,
        //         left: 5.0,
        //       ),
        contentPadding:
            expanded ? const EdgeInsets.fromLTRB(0, 16, 12, 10) : null,
        hintText: 'Título',
        hintStyle: TextStyle(
          fontSize: 24,
          height: expanded ? null : 2.5,
          fontFamily: 'JosefinSans',
          fontWeight: FontWeight.w600,
          color: ColorPalettes.grey.withOpacity(0.2),
        ),
        border: InputBorder.none,
      ),
    );
  }
}
