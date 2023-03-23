import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../reactive/i_reactive_list.dart';
import '../stores/selection_store.dart';

class GridFolderWidget extends StatelessWidget {
  final bool selectable;
  final SelectionStore selection;
  final IReactiveList reactive;

  final List<FolderModel> listFolders;
  final List<FolderModel> folderSelecteds;

  final Function(FolderModel) onTap;
  final Function() onLongPressCardFolder;

  const GridFolderWidget({
    Key? key,
    required this.selectable,
    required this.selection,
    required this.reactive,
    required this.listFolders,
    required this.folderSelecteds,
    required this.onLongPressCardFolder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: listFolders.map((folder) {
          if (selectable) {
            return CardFolderEditable(
              qtd: reactive.numberChildrenInFolder(folder),
              title: folder.name,
              background: Color(folder.color),
              selected: folderSelecteds.contains(folder),
              onDeselect: () {
                selection.removeItemFolderSelection(folder);
              },
              onLongPress: () {
                selection.addItemFolderToSelection(folder);
              },
            );
          }
          return CardFolder(
            qtd: reactive.numberChildrenInFolder(folder),
            title: folder.name,
            background: Color(folder.color),
            onTap: () => onTap(folder),
            onLongPress: () {
              onLongPressCardFolder.call();
              selection.toggleSelectable(true);
              selection.addItemFolderToSelection(folder);
            },
          );
        }).toList(),
      ),
    );
  }
}
