import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../stores/selection_store.dart';

class GridFolderWidget extends StatelessWidget {
  final bool selectable;
  final SelectionStore selection;
  final List<FolderQtdChildView> listFolders;
  final List<FolderQtdChildView> folderSelecteds;

  final Function()? onTap;
  final Function() onLongPressCardFolder;

  const GridFolderWidget({
    Key? key,
    required this.selectable,
    required this.selection,
    required this.listFolders,
    required this.folderSelecteds,
    required this.onLongPressCardFolder,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: listFolders.map((folder) {
          if (selectable) {
            return CardFolderEditable(
              qtd: folder.qtd,
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
            qtd: folder.qtd,
            title: folder.name,
            background: Color(folder.color),
            onTap: onTap,
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
