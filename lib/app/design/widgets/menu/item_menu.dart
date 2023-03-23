import 'package:flutter/material.dart';

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
          ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2)
          : Theme.of(context).drawerTheme.backgroundColor,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        minLeadingWidth: 0.0,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(
            start: paddingStart,
            bottom: 5.0,
          ),
          child: Icon(
            icon,
            color: colorIcon != null
                ? Color(colorIcon!)
                : Theme.of(context).colorScheme.inversePrimary,
            size: sizeIcon,
          ),
        ),
        title: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: selected ? 16 : null,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.inverseSurface
                : Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
