import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/modules/dashboard/presenter/reactive/i_reactive_list.dart';
import 'package:safe_notes/app/shared/database/models/folder_list_model.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import '../pages/drawer/drawer_menu_controller.dart';

class LadderFolderForMove extends StatefulWidget {
  final int currentParentFolder;
  final List<FolderModel> listFolder;
  final Function(int folderId, int level) onChangeParentFolder;

  const LadderFolderForMove({
    required this.listFolder,
    required this.currentParentFolder,
    required this.onChangeParentFolder,
    Key? key,
  }) : super(key: key);

  @override
  State<LadderFolderForMove> createState() => _LadderFolderForMoveState();
}

class _LadderFolderForMoveState extends State<LadderFolderForMove> {
  late IReactiveList _reactiveList;

  int parentFolderId = 0;
  bool changeFolder = false;
  Map<int, bool> expandableFolders = {};

  FolderListModel? folderers;
  List<FolderModel> _listFolders = [];

  void reorganization() {
    _listFolders.sort((previous, posterior) {
      return previous.level.compareTo(posterior.level);
    });

    if (_listFolders.isNotEmpty) {
      folderers = FolderListModel(current: _listFolders.first);
      insertChildrens(folderers!);
    }
  }

  void insertChildrens(FolderListModel listFolderModel) {
    FolderModel currentFolder;
    int parentId = listFolderModel.current.folderId;
    int childLevel = listFolderModel.current.level + 1;

    for (int i = 0; i < _listFolders.length; i++) {
      currentFolder = _listFolders[i];

      if (currentFolder.level == childLevel &&
          currentFolder.folderParent == parentId) {
        var child = FolderListModel(current: currentFolder);
        insertChildrens(child);
        listFolderModel.childrens.add(child);
      }
    }
  }

  bool isExpanded(int folderId) {
    if (changeFolder) {
      return expandableFolders[folderId] ?? false;
    } else {
      if (expandableFolders.containsKey(folderId)) {
        expandableFolders[folderId] = false;
      } else {
        expandableFolders.addAll({folderId: false});
      }
      return false;
    }
  }

  bool _allowChildrens(FolderModel childFolder) {
    return !widget.listFolder.any((model) {
      return model.folderId == childFolder.folderId;
    });
  }

  String qtdChildrenFolder(int qtd) => (qtd == 0) ? '' : qtd.toString();

  @override
  void initState() {
    super.initState();
    parentFolderId = widget.currentParentFolder;
    _reactiveList =
        Modular.get<DrawerMenuController>().listFieldsStore.reactive;
    _listFolders = _reactiveList.listFolder;
    reorganization();
  }

  @override
  Widget build(BuildContext context) {
    if (_listFolders.isEmpty) return Container();

    return FolderExpansionTile(
      initiallyExpanded: isExpanded(
        folderers!.current.folderId,
      ),
      selected: parentFolderId == folderers!.current.folderId,
      title: folderers!.current.name,
      fontColor: Theme.of(context).colorScheme.tertiary,
      backgroundColor: Colors.transparent,
      iconColor: Color(folderers!.current.color),
      turnsColor: Theme.of(context).colorScheme.inversePrimary,
      selectedColor:
          Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.6),
      trailing: Text(
        qtdChildrenFolder(
          _reactiveList.numberChildrenInFolder(folderers!.current),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      children: generaterWidgetsFolders(context, folderers!.childrens),
      onExpansionChanged: (bool isExpanded) {
        if (expandableFolders.containsKey(folderers!.current.folderId)) {
          expandableFolders[folderers!.current.folderId] = isExpanded;
        } else {
          expandableFolders.addAll(
            {folderers!.current.folderId: isExpanded},
          );
        }
      },
      onPressed: () {
        setState(() {
          changeFolder = true;
          parentFolderId = folderers!.current.folderId;
        });
        widget.onChangeParentFolder(
          folderers!.current.folderId,
          folderers!.current.level,
        );
      },
    );
  }

  List<Widget> generaterWidgetsFolders(
    BuildContext context,
    List<FolderListModel> listFolderChildrens,
  ) {
    double padding = 4.0;
    List<Widget> list = [];

    for (var folderChild in listFolderChildrens) {
      padding = folderChild.current.level * 15.0;
      if (folderChild.current.level > 4) {
        padding = 4 * 15.0;
      }

      list.add(
        CustomExpansionTile(
          spaceStart: padding,
          initiallyExpanded: isExpanded(
            folderChild.current.folderId,
          ),
          selected: parentFolderId == folderChild.current.folderId,
          backgroundColor: Colors.transparent,
          turnsColor: Theme.of(context).colorScheme.inversePrimary,
          selectedColor:
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.6),
          leading: Icon(
            Icons.folder_outlined,
            color: Color(folderChild.current.color),
          ),
          title: Text(
            folderChild.current.name,
            maxLines: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              height: 1.7,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          trailing: Text(
            qtdChildrenFolder(
              _reactiveList.numberChildrenInFolder(folderChild.current),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          children: _allowChildrens(folderChild.current)
              ? generaterWidgetsFolders(context, folderChild.childrens)
              : [],
          onExpansionChanged: (bool isExpanded) {
            if (expandableFolders.containsKey(folderChild.current.folderId)) {
              expandableFolders[folderChild.current.folderId] = isExpanded;
            } else {
              expandableFolders.addAll(
                {folderChild.current.folderId: isExpanded},
              );
            }
          },
          onPressed: () {
            var isCurrentFolder = widget.listFolder.any((folder) {
              return folder.folderId == folderChild.current.folderId;
            });
            if (!isCurrentFolder) {
              setState(() {
                changeFolder = true;
                parentFolderId = folderChild.current.folderId;
              });
              widget.onChangeParentFolder(
                folderChild.current.folderId,
                folderChild.current.level,
              );
            }
          },
        ),
      );
    }
    return list;
  }
}
