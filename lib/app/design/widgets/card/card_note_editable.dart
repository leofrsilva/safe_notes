import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

class CardNoteEditable extends StatelessWidget {
  final bool selected;
  final NoteModel note;
  final Function() onDeselect;
  final Function() onLongPress;

  final Widget? foreground;

  const CardNoteEditable({
    Key? key,
    this.foreground,
    required this.note,
    required this.selected,
    required this.onDeselect,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CardNote(
              foreground: foreground,
              title: note.title,
              body: note.body,
              favorite: note.favorite,
              date: note.dateModification,
              onLongPress: onLongPress,
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
                padding: const EdgeInsetsDirectional.only(
                  start: 15.25,
                  top: 11.5,
                ),
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
                padding: const EdgeInsets.only(left: 4.0),
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
