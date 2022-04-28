import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/styles/color_palettes.dart';
import 'package:safe_notes/app/design/widgets/expansion/custom_expansion_tile.dart';
import 'package:safe_notes/app/design/widgets/expansion/folder_expansion_tile.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/database/views/list_folder_qtd_child_view.dart';

// ignore: must_be_immutable
class LadderFolder extends StatelessWidget {
  late Color colorTile;
  late ListFolderQtdChildView folderers;
  final List<FolderQtdChildView> listFolders;
  bool selected = false;

  LadderFolder({
    Key? key,
    required this.listFolders,
  }) : super(key: key) {
    reorganization();
  }

  reorganization() {
    //? TEMP -------
    listFolders.sort((previous, posterior) {
      return previous.id.compareTo(posterior.id);
    });
    //? ------------
    listFolders.sort((previous, posterior) {
      return previous.level.compareTo(posterior.level);
    });

    if (listFolders.isNotEmpty) {
      folderers = ListFolderQtdChildView(current: listFolders.first);
      insertChildrens(folderers);
    }
  }

  void insertChildrens(ListFolderQtdChildView listFolderQtdChildView) {
    FolderQtdChildView currentFolder;
    int parentId = listFolderQtdChildView.current.id;
    int childLevel = listFolderQtdChildView.current.level + 1;

    for (int i = 0; i < listFolders.length; i++) {
      currentFolder = listFolders[i];

      if (currentFolder.level == childLevel &&
          currentFolder.parentId == parentId) {
        var child = ListFolderQtdChildView(current: currentFolder);
        insertChildrens(child);
        listFolderQtdChildView.childrens.add(child);
      }
    }
  }

  List<Widget> generaterWidgetsFolders(
      List<ListFolderQtdChildView> listFolderChildrens) {
    double padding = 4.0;
    List<Widget> list = [];

    for (var folderChild in listFolderChildrens) {
      padding = folderChild.current.level * 15.0;
      if (folderChild.current.level > 4) {
        padding = 4 * 15.0;
      }

      list.add(CustomExpansionTile(
        selected: selected,
        spaceStart: padding,
        backgroundColor: colorTile,
        turnsColor: ColorPalettes.secondy.withOpacity(0.5),
        selectedColor: ColorPalettes.blueGrey.withOpacity(0.2),
        leading: Icon(
          Icons.folder_outlined,
          color: Color(folderChild.current.color),
        ),
        title: Text(
          folderChild.current.name,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: selected ? 16 : null,
            fontFamily: 'JosefinSans',
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            color: ColorPalettes.white,
          ),
        ),
        trailing: folderChild.current.qtd != 0
            ? Text(
                folderChild.current.qtd.toString(),
                style: TextStyle(
                  color: ColorPalettes.secondy,
                ),
              )
            : null,
        children: generaterWidgetsFolders(folderChild.childrens),
        onPressed: () {
          print(folderChild.current.name);
        },
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (listFolders.isEmpty) return Container();

    colorTile = Theme.of(context).primaryColor;
    return FolderExpansionTile(
      selected: selected,
      title: folderers.current.name,
      backgroundColor: colorTile,
      iconColor: Color(folderers.current.color),
      turnsColor: ColorPalettes.secondy.withOpacity(0.5),
      selectedColor: ColorPalettes.blueGrey.withOpacity(0.2),
      trailing: folderers.current.qtd != 0
          ? Text(
              folderers.current.qtd.toString(),
              style: TextStyle(
                color: ColorPalettes.secondy,
              ),
            )
          : null,
      children: generaterWidgetsFolders(folderers.childrens),
      onPressed: () {
        print(folderers.current.name);
      },
    );
  }
}
