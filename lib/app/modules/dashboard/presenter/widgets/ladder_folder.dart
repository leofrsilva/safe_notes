import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/style/color_palettes.dart';
import 'package:safe_notes/app/design/widgets/expansion/custom_expansion_tile.dart';
import 'package:safe_notes/app/design/widgets/expansion/folder_expansion_tile.dart';
import 'package:safe_notes/app/shared/database/models/folder_list_model.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../pages/drawer/drawer_menu_controller.dart';
import '../reactive/i_reactive_list.dart';

class LadderFolder extends StatefulWidget {
  final Function(FolderModel) onTapFolder;
  final List<FolderModel> listFolders;
  final int selected;

  const LadderFolder({
    Key? key,
    required this.selected,
    required this.listFolders,
    required this.onTapFolder,
  }) : super(key: key);

  @override
  State<LadderFolder> createState() => _LadderFolderState();
}

class _LadderFolderState extends State<LadderFolder> {
  late IReactiveList _reactiveList;

  FolderListModel? folderers;
  int selectedFolderId = 0;

  void reorganization() {
    widget.listFolders.sort((previous, posterior) {
      return previous.level.compareTo(posterior.level);
    });

    if (widget.listFolders.isNotEmpty) {
      folderers = FolderListModel(current: widget.listFolders.first);
      insertChildrens(folderers!);
    }
  }

  void insertChildrens(FolderListModel listFolderModel) {
    FolderModel currentFolder;
    int parentId = listFolderModel.current.folderId;
    int childLevel = listFolderModel.current.level + 1;

    for (int i = 0; i < widget.listFolders.length; i++) {
      currentFolder = widget.listFolders[i];

      if (currentFolder.level == childLevel &&
          currentFolder.folderParent == parentId) {
        var child = FolderListModel(current: currentFolder);
        insertChildrens(child);
        listFolderModel.childrens.add(child);
      }
    }
  }

  bool isExpanded(int folderId) {
    return _reactiveList.checkFolderIsExpanded(folderId);
  }

  String qtdChildrenFolder(int qtd) {
    if (qtd == 0) return '';
    return qtd.toString();
  }

  @override
  void initState() {
    super.initState();
    _reactiveList =
        Modular.get<DrawerMenuController>().listFieldsStore.reactive;
    reorganization();
    selectedFolderId = widget.selected;
  }

  @override
  void didUpdateWidget(covariant LadderFolder oldWidget) {
    super.didUpdateWidget(oldWidget);
    reorganization();
    selectedFolderId = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listFolders.isEmpty) return Container();

    return FolderExpansionTile(
      initiallyExpanded: isExpanded(folderers!.current.folderId),
      selected: widget.selected == folderers!.current.folderId,
      title: folderers!.current.name,
      iconColor: Color(folderers!.current.color),
      turnsColor: ColorPalettes.secondy.withOpacity(0.5),
      selectedColor: ColorPalettes.blueGrey.withOpacity(0.2),
      trailing: Text(
        qtdChildrenFolder(
          _reactiveList.numberChildrenInFolder(folderers!.current),
        ),
        style: TextStyle(color: ColorPalettes.secondy),
      ),
      children: generaterWidgetsFolders(folderers!.childrens),
      onExpansionChanged: (bool isExpanded) {
        if (isExpanded) {
          _reactiveList.expanded(folderId: folderers!.current.folderId);
        } else {
          _reactiveList.notExpanded(folderId: folderers!.current.folderId);
        }
      },
      onPressed: () {
        widget.onTapFolder(folderers!.current);
      },
    );
  }

  List<Widget> generaterWidgetsFolders(
      List<FolderListModel> listFolderChildrens) {
    double padding = 4.0;
    List<Widget> list = [];

    for (var folderChild in listFolderChildrens) {
      padding = folderChild.current.level * 15.0;
      if (folderChild.current.level > 4) {
        padding = 4 * 15.0;
      }

      list.add(CustomExpansionTile(
        initiallyExpanded: isExpanded(folderChild.current.folderId),
        selected: widget.selected == folderChild.current.folderId,
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
            fontSize:
                widget.selected == folderChild.current.folderId ? 16 : null,
            fontFamily: 'JosefinSans',
            fontWeight: widget.selected == folderChild.current.folderId
                ? FontWeight.bold
                : FontWeight.w600,
            color: ColorPalettes.white,
          ),
        ),
        trailing: Text(
          qtdChildrenFolder(
            _reactiveList.numberChildrenInFolder(folderChild.current),
          ),
          style: TextStyle(color: ColorPalettes.secondy),
        ),
        children: generaterWidgetsFolders(folderChild.childrens),
        onExpansionChanged: (bool isExpanded) {
          if (isExpanded) {
            _reactiveList.expanded(folderId: folderChild.current.folderId);
          } else {
            _reactiveList.notExpanded(folderId: folderChild.current.folderId);
          }
        },
        onPressed: () {
          widget.onTapFolder(folderChild.current);
        },
      ));
    }
    return list;
  }
}
