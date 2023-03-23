import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/util/utils.dart';
import 'package:safe_notes/app/design/widgets/textfield/text_overflow_field.dart';

import '../../../../presenter/enum/mode_view_enum.dart';

class CustomTextFieldTitleNote extends StatelessWidget {
  const CustomTextFieldTitleNote({
    Key? key,
    required this.modeView,
    required this.expanded,
    required this.isFavorite,
    this.widthActions = 50,
    this.actions,
    this.childDetails,
    this.onChanged,
    this.onTapIcon,
    this.onTapFavorite,
    this.onPressedModelView,
    this.turnsColor,
    this.onTapTextField,
    this.heightExpanded = 135,
    this.heightNotExpanded = 50,
    required this.controller,
    this.initialFocus = true,
    this.turnsCurve = Curves.easeIn,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final ModeViewEnum modeView;
  final Function()? onPressedModelView;

  final bool initialFocus;
  final TextEditingController controller;

  final bool expanded;
  final bool isFavorite;
  final Widget? childDetails;
  final List<Widget>? actions;
  final double widthActions;

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

    List<Widget> iconActions = actions ?? [];
    if (onPressedModelView != null) {
      if (modeView == ModeViewEnum.reading) {
        iconActions.add(IconButton(
          color: Colors.grey,
          // color: ColorPalettes.grey,
          icon: const Icon(Icons.menu_book_rounded),
          onPressed: onPressedModelView,
        ));
      } else {
        iconActions.add(IconButton(
          color: Colors.grey,
          // color: ColorPalettes.grey,
          icon: const Icon(Icons.edit_note),
          onPressed: onPressedModelView,
        ));
      }
    }

    return AnimatedContainer(
      curve: turnsCurve,
      duration: duration,
      height: expanded ? heightExpanded : heightNotExpanded,
      decoration: BoxDecoration(
        // color:  ColorPalettes.transparent,
        color: Theme.of(context).colorScheme.background,
        // color: Colors.amber,
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Stack(
        children: [
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
                  width: Sizes.width(context) - (widthActions - 25.0),
                  alignment: Alignment.center,
                  child: _textField(context),
                ),
                AnimatedOpacity(
                  opacity: expanded ? 1.0 : 0.0,
                  duration: duration,
                  child: details,
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: expanded ? 0.0 : 1.0,
            duration: duration,
            child: SizedBox(
              width: widthActions,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconActions,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: expanded ? 1.0 : 0.0,
            duration: duration,
            child: Align(
              alignment: Alignment.topRight,
              child: iconFavorite(context),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: iconArrow(context),
          ),
        ],
      ),
    );
  }

  Widget iconFavorite(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      icon: Icon(
        isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
        color: isFavorite ? Theme.of(context).colorScheme.primary : null,
        // color: isFavorite ? ColorPalettes.yellow : ColorPalettes.grey,
        size: 30,
      ),
      onPressed: onTapFavorite,
    );
  }

  Widget iconArrow(BuildContext context) {
    return InkWell(
      onTap: onTapIcon,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: AnimatedRotation(
          turns: expanded ? 0.25 : 0.0,
          duration: duration,
          child: Icon(
            Icons.keyboard_arrow_left,
            color: turnsColor,
            size: 32,
          ),
        ),
      ),
    );
    // return IconButton(
    //   visualDensity: VisualDensity.compact,
    //   padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    //   icon: AnimatedRotation(
    //     turns: expanded ? 0.25 : 0.0,
    //     duration: duration,
    //     child: Icon(
    //       Icons.keyboard_arrow_left,
    //       color: turnsColor ?? Theme.of(context).primaryColor,
    //       size: 32,
    //     ),
    //   ),
    //   onPressed: onTapIcon,
    // );
  }

  Widget _textField(BuildContext context) {
    return TextOverflowField(
      minWidth: Sizes.width(context) - (widthActions - 25.0),
      canRequestFocus: expanded ? initialFocus : null,
      height: heightNotExpanded,
      controller: controller,
      spaceTop: 4.0,
      spaceLeft: 0.0,
      spaceRight: 12,
      onTapTextField: onTapTextField,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 24,
        // height: expanded ? null : 3.5,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600,
      ),
      hintText: 'Título',
      hintStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      border: InputBorder.none,
    );
  }
}
