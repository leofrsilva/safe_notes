import 'package:flutter/material.dart';

import 'card_folder.dart';

class CardFolderEditable extends StatelessWidget {
  final int qtd;
  final String title;
  final Color? color;
  final Color background;

  final bool selected;
  final Function() onDeselect;
  final Function() onLongPress;

  const CardFolderEditable({
    Key? key,
    this.color,
    required this.qtd,
    required this.title,
    required this.background,
    required this.onLongPress,
    required this.onDeselect,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CardFolder(
              qtd: qtd,
              title: title,
              color: color,
              background: background,
              onTap: () {
                if (selected) {
                  onDeselect.call();
                } else {
                  onLongPress.call();
                }
              },
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: CircleAvatar(
                  radius: 8.5,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.white60
                          : Colors.black38,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Checkbox(
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).colorScheme.secondary;
                  }),
                  side: MaterialStateBorderSide.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return null;
                    }
                    return BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.25,
                    );
                  }),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  value: selected,
                  onChanged: (value) {
                    value = value ?? false;
                    if (value) {
                      onLongPress.call();
                    } else {
                      onDeselect.call();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
