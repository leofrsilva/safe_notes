import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

import '../../../presenter/reactive/reactive_list_folder.dart';
import 'manager_folders_controller.dart';
import 'widgets/ladder_folder_manager.dart';

class ManagerFoldersPage extends StatefulWidget {
  const ManagerFoldersPage({Key? key}) : super(key: key);

  @override
  State<ManagerFoldersPage> createState() => _ManagerFoldersPageState();
}

class _ManagerFoldersPageState extends State<ManagerFoldersPage> {
  late ReactiveListFolder _reactiveListFolder;
  late ManagerFoldersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ManagerFoldersController>();
    _reactiveListFolder = _controller.reactiveListFolder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Pastas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 26),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: ColorPalettes.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _reactiveListFolder,
                builder: (context, child) {
                  return LadderFolderManager(
                    listFolders: _reactiveListFolder.listFolder,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Divider(
                  thickness: 2.0,
                  color: ColorPalettes.whiteSemiTransparent,
                ),
              ),
              InkWell(
                onTap: () => _controller.callAddSubFolderPage(
                    context, _reactiveListFolder.listFolder.first),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          Icons.add_outlined,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      Text(
                        'Criar Pasta',
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 16.0,
                          fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.w600,
                          color: ColorPalettes.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),

        // child: AnimatedBuilder(
        //   animation: _drawerMenuController.listFolders.reactiveListFolder,
        //   builder: (context, child) {
        //     final reactiveListFolder =
        //         _drawerMenuController.listFolders.reactiveListFolder;
        //     return LadderFolder(
        //       listFolders: _reactiveListFolder.list,
        //     );
        //   },
        // ),
        /////
        // child: StreamBuilder<List<FolderQtdChildView>>(
        //   stream: _drawerMenuController.listFolders.selectState.value,
        //   builder: ((context, snapshot) {
        //     if (snapshot.hasData) {
        //       if (snapshot.connectionState == ConnectionState.done ||
        //           snapshot.connectionState == ConnectionState.active) {
        //         final listFolders = snapshot.data ?? [];
        //         return LadderFolder(listFolders: listFolders);
        //       }
        //     }
        //     return Container();
        //   }),
        // ),
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
