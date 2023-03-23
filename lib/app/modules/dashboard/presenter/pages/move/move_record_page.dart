import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../widgets/ladder_folder_for_move.dart';

class MoveRecordPage extends StatelessWidget {
  final List<FolderModel> allFolders;
  final List<FolderModel> selectFolders;
  final List<NoteModel> selectNotes;
  final Function(BuildContext, List<FolderModel>) updateFolders;
  final Function(BuildContext, List<NoteModel>) updateNotes;

  MoveRecordPage({
    required this.allFolders,
    required this.selectFolders,
    required this.selectNotes,
    required this.updateFolders,
    required this.updateNotes,
    super.key,
  });

  final folders = <FolderModel>[];
  void updateFolderChildrens(FolderModel currentFolder) {
    FolderModel childFolder;

    for (int i = 0; i < allFolders.length; i++) {
      childFolder = allFolders[i];

      if (childFolder.folderParent == currentFolder.folderId) {
        childFolder = childFolder.copyWith(
          level: currentFolder.level + 1,
        );
        updateFolderChildrens(childFolder);
        folders.add(childFolder);
      }
    }
  }

  _close(BuildContext context, bool? result) {
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    int level = 0;
    int initialFolderId = 0;
    int parentFolderId = 0;

    if (selectFolders.isNotEmpty) {
      parentFolderId = selectFolders.first.folderParent ?? 0;
    } else if (selectNotes.isNotEmpty) {
      parentFolderId = selectNotes.first.folderId;
    }
    initialFolderId = parentFolderId;

    return Container(
      height: Sizes.height(context) * 0.6,
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Container(
            width: 50.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LadderFolderForMove(
                    listFolder: selectFolders,
                    currentParentFolder: parentFolderId,
                    onChangeParentFolder: (newParentFolder, newLevel) {
                      parentFolderId = newParentFolder;
                      level = newLevel;
                    }),
              ],
            ),
          )),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Mover para cá'),
                  onPressed: () {
                    if (parentFolderId == initialFolderId) {
                      _close(context, false);
                    } else {
                      if (selectFolders.isNotEmpty) {
                        folders.clear();

                        for (var folder in selectFolders) {
                          folder = folder.copyWith(
                            folderParent: parentFolderId,
                            level: level + 1,
                          );
                          folders.add(folder);
                          updateFolderChildrens(folder);
                        }
                        updateFolders(context, folders);
                      }
                      if (selectNotes.isNotEmpty) {
                        List<NoteModel> notes = [];
                        for (var note in selectNotes) {
                          notes.add(note.copyWith(folderId: parentFolderId));
                        }
                        updateNotes(context, notes);
                      }
                      _close(context, true);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
