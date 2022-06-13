import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

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
                  backgroundColor: ColorPalettes.white,
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
                      return ColorPalettes.secondy;
                    }
                    return ColorPalettes.grey;
                  }),
                  side: MaterialStateBorderSide.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return null;
                    }
                    return const BorderSide(
                      color: Colors.grey,
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
