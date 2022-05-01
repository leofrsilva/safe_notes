import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../widgets/ladder_folder.dart';
import '../drawer/drawer_menu_controller.dart';
import '../drawer/stores/list_folders_store.dart';

class ManagerFolderPage extends StatefulWidget {
  const ManagerFolderPage({Key? key}) : super(key: key);

  @override
  State<ManagerFolderPage> createState() => _ManagerFolderPageState();
}

class _ManagerFolderPageState extends State<ManagerFolderPage> {
  late DrawerMenuController _drawerMenuController;

  @override
  void initState() {
    super.initState();
    _drawerMenuController = Modular.get<DrawerMenuController>();
  }

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        title: Text(
          'Gerenciar Pastas',
          style: TextStyle(
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
            size: 26,
          ),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: ColorPalettes.white,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: ScopedBuilder<ListFoldersStore, Failure,
                Stream<List<FolderQtdChildView>>>.transition(
            store: Modular.get<ListFoldersStore>(),
            onState: (context, state) {
              return StreamBuilder<List<FolderQtdChildView>>(
                stream: state,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      final listFolders = snapshot.data ?? [];
                      return LadderFolder(listFolders: listFolders);
                    }
                  }
                  return Container();
                }),
              );
            }),
      ),
      // child: ScopedBuilder<ListFoldersStore, Failure,
      //     Stream<List<FolderQtdChildView>>>.transition(
      //   store: _drawerMenuController.listFolders,
      //   onLoading: (context) => const Center(
      //     child: CircularProgressIndicator.adaptive(),
      //   ),
      //   onError: (context, _) {
      //     return const Center(
      //       child: Text(
      //         'Erro ao Carregar as Pastas',
      //         style: TextStyle(
      //           fontFamily: 'JosefinSans',
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //     );
      //   },
      //   onState: (context, state) {
      //     return StreamBuilder<List<FolderQtdChildView>>(
      //       stream: state,
      //       builder: ((context, snapshot) {
      //         if (snapshot.hasData) {
      //           if (snapshot.connectionState == ConnectionState.done ||
      //               snapshot.connectionState == ConnectionState.active) {
      //             final listFolders = snapshot.data ?? [];
      //             return LadderFolder(listFolders: listFolders);
      //           }
      //         }
      //         return Container();
      //       }),
      //     );
      //   },
      // ),
    );
  }
}
