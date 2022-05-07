import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/styles/color_palettes.dart';
import 'package:safe_notes/app/design/widgets/expansion/custom_expansion_tile.dart';
import 'package:safe_notes/app/design/widgets/expansion/folder_expansion_tile.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/database/views/list_folder_qtd_child_view.dart';

import '../pages/drawer/drawer_menu_controller.dart';

class LadderFolder extends StatefulWidget {
  final Function(int) onTapFolder;
  final List<FolderQtdChildView> listFolders;

  const LadderFolder({
    Key? key,
    required this.listFolders,
    required this.onTapFolder,
  }) : super(key: key);

  @override
  State<LadderFolder> createState() => _LadderFolderState();
}

class _LadderFolderState extends State<LadderFolder> {
  final _reactiveListFolder =
      Modular.get<DrawerMenuController>().reactiveListFolder;

  bool selected = false;

  ListFolderQtdChildView? folderers;

  void reorganization() {
    widget.listFolders.sort((previous, posterior) {
      return previous.level.compareTo(posterior.level);
    });

    if (widget.listFolders.isNotEmpty) {
      folderers = ListFolderQtdChildView(current: widget.listFolders.first);
      insertChildrens(folderers!);
    }
  }

  void insertChildrens(ListFolderQtdChildView listFolderQtdChildView) {
    FolderQtdChildView currentFolder;
    int parentId = listFolderQtdChildView.current.id;
    int childLevel = listFolderQtdChildView.current.level + 1;

    for (int i = 0; i < widget.listFolders.length; i++) {
      currentFolder = widget.listFolders[i];

      if (currentFolder.level == childLevel &&
          currentFolder.parentId == parentId) {
        var child = ListFolderQtdChildView(current: currentFolder);
        insertChildrens(child);
        listFolderQtdChildView.childrens.add(child);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    reorganization();
  }

  @override
  void didUpdateWidget(covariant LadderFolder oldWidget) {
    super.didUpdateWidget(oldWidget);
    reorganization();
  }

  bool isExpanded(int folderId) {
    return _reactiveListFolder.checkFolderIsExpanded(folderId);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listFolders.isEmpty) return Container();

    return FolderExpansionTile(
      initiallyExpanded: isExpanded(folderers!.current.id),
      selected: selected,
      title: folderers!.current.name,
      iconColor: Color(folderers!.current.color),
      turnsColor: ColorPalettes.secondy.withOpacity(0.5),
      selectedColor: ColorPalettes.blueGrey.withOpacity(0.2),
      trailing: folderers!.current.qtd != 0
          ? Text(
              folderers!.current.qtd.toString(),
              style: TextStyle(
                color: ColorPalettes.secondy,
              ),
            )
          : null,
      children: generaterWidgetsFolders(folderers!.childrens),
      onExpansionChanged: (bool isExpanded) {
        if (isExpanded) {
          _reactiveListFolder.expanded(folderId: folderers!.current.id);
        } else {
          _reactiveListFolder.notExpanded(folderId: folderers!.current.id);
        }
      },
      onPressed: () {
        widget.onTapFolder(folderers!.current.id);
      },
    );
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
        initiallyExpanded: isExpanded(
          folderChild.current.id,
        ),
        selected: selected,
        spaceStart: padding,
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
            height: 1.6,
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
        onExpansionChanged: (bool isExpanded) {
          if (isExpanded) {
            _reactiveListFolder.expanded(folderId: folderChild.current.id);
          } else {
            _reactiveListFolder.notExpanded(folderId: folderChild.current.id);
          }
        },
        onPressed: () {
          widget.onTapFolder(folderChild.current.id);
        },
      ));
    }
    return list;
  }
}
