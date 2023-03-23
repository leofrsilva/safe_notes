import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../../presenter/enum/mode_note_enum.dart';

class DetailsNoteWidget extends StatelessWidget {
  final ModeNoteEnum mode;
  final NoteModel noteModel;
  final FolderModel folder;

  const DetailsNoteWidget({
    Key? key,
    required this.mode,
    required this.folder,
    required this.noteModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var infoFolder = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_outlined,
          color: Color(folder.color),
        ),
        const SizedBox(width: 6.0),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            folder.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
    if (mode == ModeNoteEnum.edit) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoFolder,
          const SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Última modificação: ${noteModel.dateModification.toStrDateTime}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 1.0),
              Text(
                'Criado: ${noteModel.dateCreate.toStrDate}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      );
    }
    return infoFolder;
  }
}
