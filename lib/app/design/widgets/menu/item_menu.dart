import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/styles/color_palettes.dart';

class ItemMenu extends StatelessWidget {
  final String text;
  final bool selected;
  final int? colorIcon;
  final IconData? icon;
  final Widget? trailing;
  final double? sizeIcon;
  final double paddingStart;
  final Function()? onTap;

  const ItemMenu({
    required this.text,
    this.icon,
    this.paddingStart = 0.0,
    this.selected = false,
    this.trailing,
    this.sizeIcon,
    this.colorIcon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? ColorPalettes.blueGrey.withOpacity(0.2)
          : Theme.of(context).primaryColor,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Padding(
          padding: EdgeInsetsDirectional.only(
            start: paddingStart,
            bottom: 5.0,
          ),
          child: Icon(
            icon,
            color:
                colorIcon != null ? Color(colorIcon!) : ColorPalettes.secondy,
            size: sizeIcon,
          ),
        ),
        minLeadingWidth: 0.0,
        title: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: selected ? 16 : null,
            fontFamily: 'JosefinSans',
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            color: ColorPalettes.white,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
