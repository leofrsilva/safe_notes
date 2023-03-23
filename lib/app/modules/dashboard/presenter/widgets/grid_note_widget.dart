import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../stores/selection_store.dart';

class GridNoteWidget extends StatelessWidget {
  final bool selectable;
  final SelectionStore selection;
  final bool haveOrdenation;

  final bool ordeByDesc;
  final List<NoteModel> listNotes;
  final List<NoteModel> noteSelecteds;

  final Function(NoteModel) onTap;
  final Function()? onPressedOrder;
  final Function() onLongPressCardFolder;

  const GridNoteWidget({
    Key? key,
    required this.selectable,
    required this.selection,
    required this.ordeByDesc,
    required this.listNotes,
    required this.noteSelecteds,
    required this.onLongPressCardFolder,
    required this.onTap,
    this.onPressedOrder,
    this.haveOrdenation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (listNotes.isNotEmpty && haveOrdenation)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.align_horizontal_left_rounded,
                  color:
                      selectable ? Theme.of(context).colorScheme.outline : null,
                  size: 15,
                ),
                const SizedBox(width: 1.0),
                Text(
                  'Data de Modificação |',
                  style: TextStyle(
                    color: selectable
                        ? Theme.of(context).colorScheme.outline
                        : null,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    ordeByDesc
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    size: 20,
                  ),
                  onPressed: selectable ? null : onPressedOrder,
                ),
              ],
            ),
          ),
        Wrap(
          alignment: listNotes.length > 2
              ? WrapAlignment.spaceAround
              : WrapAlignment.start,
          children: listNotes.map((note) {
            if (selectable) {
              return CardNoteEditable(
                note: note,
                selected: noteSelecteds.contains(note),
                onDeselect: () {
                  selection.removeItemNoteSelection(note);
                },
                onLongPress: () {
                  selection.addItemNoteToSelection(note);
                },
              );
            }
            return CardNote(
              title: note.title,
              body: note.body,
              favorite: note.favorite,
              date: note.dateModification,
              onLongPress: () {
                onLongPressCardFolder.call();
                selection.toggleSelectable(true);
                selection.addItemNoteToSelection(note);
              },
              onTap: () => onTap(note),
            );
          }).toList(),
        ),
      ],
    );
  }
}
