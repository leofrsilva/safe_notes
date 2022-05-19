import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/database/views/list_folder_qtd_child_view.dart';

import '../../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../../presenter/reactive/reactive_list_folder.dart';
import '../manager_folders_controller.dart';

enum ActionFolder {
  createSubpasta,
  rename,
  delete,
  alterColor,
}

class LadderFolderManager extends StatefulWidget {
  final List<FolderQtdChildView> listFolders;
  const LadderFolderManager({
    Key? key,
    required this.listFolders,
  }) : super(key: key);

  @override
  State<LadderFolderManager> createState() => _LadderFolderManagerState();
}

class _LadderFolderManagerState extends State<LadderFolderManager> {
  late ManagerFoldersController _managerFoldersController;
  late ReactiveListFolder _reactiveListFolder;

  bool modeEdit = false;
  List<int> listSelected = [];
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

  bool isExpanded(int folderId) {
    return _reactiveListFolder.checkFolderIsExpanded(folderId);
  }

  String qtdChildrenFolder(int folderId) {
    int qtd = _reactiveListFolder.qtdChildrenFolder(folderId);
    if (qtd == 0) return '';
    return qtd.toString();
  }

  @override
  void initState() {
    super.initState();
    _managerFoldersController = Modular.get<ManagerFoldersController>();
    _reactiveListFolder =
        Modular.get<DrawerMenuController>().shared.reactiveFolders;
    reorganization();
  }

  @override
  void didUpdateWidget(covariant LadderFolderManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    reorganization();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listFolders.isEmpty) return Container();

    var popupKey = GlobalKey();
    return WillPopScope(
      onWillPop: () async {
        if (modeEdit == true) {
          setState(() => modeEdit = false);
          listSelected.clear();
          return false;
        }
        return true;
      },
      child: FolderExpansionTileWithPopup(
        keyPopUp: popupKey,
        initiallyExpanded: isExpanded(
          folderers!.current.id,
        ),
        title: folderers!.current.name,
        fontColor: ColorPalettes.blueGrey,
        backgroundColor: ColorPalettes.transparent,
        iconColor: Color(folderers!.current.color),
        turnsColor: ColorPalettes.secondy.withOpacity(0.5),
        selectedColor: ColorPalettes.blueGrey.withOpacity(0.2),
        trailing: Text(
          qtdChildrenFolder(folderers!.current.id),
          style: TextStyle(
            color: ColorPalettes.secondy,
          ),
        ),
        children: generaterWidgetsFolders(context, folderers!.childrens),
        onExpansionChanged: (bool isExpanded) {
          if (isExpanded) {
            _reactiveListFolder.expanded(folderId: folderers!.current.id);
          } else {
            _reactiveListFolder.notExpanded(folderId: folderers!.current.id);
          }
        },
        //? onLongPress: () => setState(() => modeEdit = true),
        onPressed: () async {
          if (!modeEdit) {
            final action = await showMenu<ActionFolder>(
              context: context,
              items: popUpFolderDefault(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              position: RelativeRectPosition.getRelativeRect(popupKey),
            );
            if (action != null) {
              if (action == ActionFolder.createSubpasta) {
                _managerFoldersController.callAddSubFolderPage(
                  context,
                  folderers!.current,
                );
              }
            }
          }
        },
      ),
    );
  }

  List<Widget> generaterWidgetsFolders(
    BuildContext context,
    List<ListFolderQtdChildView> listFolderChildrens,
  ) {
    double padding = 4.0;
    List<Widget> list = [];

    for (var folderChild in listFolderChildrens) {
      padding = folderChild.current.level * 15.0;
      if (folderChild.current.level > 4) {
        padding = 4 * 15.0;
      }

      var popupKey = GlobalKey();
      list.add(
        CustomExpansionTileWithPopup(
          selected: listSelected.contains(folderChild.current.id),
          modeEdit: modeEdit,
          keyPopUp: popupKey,
          initiallyExpanded: isExpanded(
            folderChild.current.id,
          ),
          spaceStart: padding,
          backgroundColor: ColorPalettes.transparent,
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
              height: 1.7,
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w600,
              color: ColorPalettes.blueGrey,
            ),
          ),
          trailing: Text(
            qtdChildrenFolder(folderChild.current.id),
            style: TextStyle(
              color: ColorPalettes.secondy,
            ),
          ),
          children: generaterWidgetsFolders(context, folderChild.childrens),
          onExpansionChanged: (bool isExpanded) {
            if (isExpanded) {
              _reactiveListFolder.expanded(folderId: folderChild.current.id);
            } else {
              _reactiveListFolder.notExpanded(folderId: folderChild.current.id);
            }
          },
          //? onLongPress: () {
          //?   setState(() {
          //?     listSelected.add(folderChild.current.id);
          //?     modeEdit = true;
          //?   });
          //? },
          onChangedCheck: (check) {
            if (check != null) {
              if (check) {
                listSelected.remove(folderChild.current.id);
              } else {
                listSelected.add(folderChild.current.id);
              }
            }
          },
          onPressed: () async {
            if (modeEdit) {
              var selected = listSelected.contains(folderChild.current.id);
              setState(() {
                if (selected) {
                  listSelected.remove(folderChild.current.id);
                } else {
                  listSelected.add(folderChild.current.id);
                }
              });
            } else {
              final action = await showMenu<ActionFolder>(
                context: context,
                items: popUpFolder(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                position: RelativeRectPosition.getRelativeRect(popupKey),
              );
              if (action != null) {
                if (action == ActionFolder.createSubpasta) {
                  _managerFoldersController.callAddSubFolderPage(
                    context,
                    folderChild.current,
                  );
                } else if (action == ActionFolder.rename) {
                  _managerFoldersController.callEditNameFolderPage(
                    context,
                    folderChild.current,
                  );
                } else if (action == ActionFolder.delete) {
                  _managerFoldersController.callDeleteFolderPage(
                    context,
                    [folderChild.current],
                  );
                } else if (action == ActionFolder.alterColor) {
                  _managerFoldersController.callEditColorFolderPage(
                    context,
                    folderChild.current,
                  );
                }
              }
            }
          },
        ),
      );
    }
    return list;
  }

  List<PopupMenuEntry<ActionFolder>> popUpFolderDefault(BuildContext context) {
    return <PopupMenuEntry<ActionFolder>>[
      PopupMenu(
        height: 38.0,
        value: ActionFolder.createSubpasta,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Text(
          'Criar subpasta',
          style: TextStyles.titleFolderList,
        ),
      ),
    ];
  }

  List<PopupMenuEntry<ActionFolder>> popUpFolder(BuildContext context) {
    return <PopupMenuEntry<ActionFolder>>[
      PopupMenu<ActionFolder>(
        height: 38.0,
        value: ActionFolder.createSubpasta,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Text(
          'Criar subpasta',
          style: TextStyles.titleFolderList,
        ),
      ),
      PopupMenu<ActionFolder>(
        height: 38.0,
        value: ActionFolder.rename,
        child: Text(
          'Renomear',
          style: TextStyles.titleFolderList,
        ),
      ),
      PopupMenu<ActionFolder>(
        height: 38.0,
        value: ActionFolder.delete,
        child: Text(
          'Excluir',
          style: TextStyles.titleFolderList,
        ),
      ),
      PopupMenu<ActionFolder>(
        height: 38.0,
        value: ActionFolder.alterColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Text(
          'Alterar cor da pasta',
          style: TextStyles.titleFolderList,
        ),
      ),
    ];
  }
}
