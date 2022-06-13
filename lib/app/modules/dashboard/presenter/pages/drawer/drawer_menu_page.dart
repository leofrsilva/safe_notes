import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/menu/item_menu.dart';
import 'package:safe_notes/app/modules/dashboard/presenter/widgets/ladder_folder.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../../submodules/folder/folder_module.dart';
import '../../../submodules/folder/presenter/folder_controller.dart';
import '../../dashboard_controller.dart';
import '../../../../../design/widgets/menu/button_manage_folders.dart';
import '../../stores/list_folders_store.dart';
import 'drawer_menu_controller.dart';

class DrawerMenuPage extends StatefulWidget {
  const DrawerMenuPage({Key? key}) : super(key: key);

  @override
  State<DrawerMenuPage> createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {
  late DashboardController _drawerController;
  late DrawerMenuController _drawerMenuController;

  onTapItemSelected(int index) async {
    _drawerMenuController.closeDrawer();
    await Future.delayed(
      _drawerMenuController.duration,
      () {
        if (0 == index) {
          Modular.to.navigate('/dashboard/mod-notes/');
        } else if (1 == index) {
          Modular.to.navigate('/dashboard/mod-favorites/');
        } else if (2 == index) {
          Modular.to.navigate('/dashboard/mod-lixeira/');
        }
      },
    );
  }

  onTapItemFolder(FolderQtdChildView folder) async {
    _drawerMenuController.closeDrawer();
    await Future.delayed(
      _drawerMenuController.duration,
      () async {
        Modular.to.navigate('/dashboard/mod-folder/');
        await Modular.isModuleReady<FolderModule>().then((_) async {
          await Future.delayed(
            _drawerMenuController.durationNavigateFolder,
            () {
              final _controllerFolder = Modular.get<FolderController>();
              _controllerFolder.folder = folder;
              _drawerMenuController.moduleFolderSaveFolderParent(folder);
            },
          );
        });
      },
    );
  }

  Widget buildListFolders() {
    return ScopedBuilder<ListFoldersStore, Failure,
        Stream<List<FolderQtdChildView>>>.transition(
      store: _drawerMenuController.shared.listFoldersStore,
      onLoading: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      onError: (context, _) {
        return const Center(
          child: Text(
            'Erro ao Carregar as Pastas',
            style: TextStyle(
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
      onState: (context, state) {
        return AnimatedBuilder(
          animation: _drawerMenuController.shared.reactiveFolders,
          builder: (context, child) {
            return Container();
          },
        );
        // return StreamBuilder<List<FolderQtdChildView>>(
        //   stream: state,
        //   builder: ((context, snapshot) {
        //     if (snapshot.hasData) {
        //       if (snapshot.connectionState == ConnectionState.done ||
        //           snapshot.connectionState == ConnectionState.active) {
        //         final listFolders = snapshot.data ?? [];
        //         _drawerMenuController.loadListFoldersIsExpanded(listFolders);
        //         return LadderFolder(listFolders: listFolders);
        //       }
        //     }
        //     return Container();
        //   }),
        // );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _drawerController = Modular.get<DashboardController>();
    _drawerMenuController = Modular.get<DrawerMenuController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: _drawerMenuController.widthExpanded,
        height: Sizes.height(context),
        child: ValueListenableBuilder<int>(
            valueListenable: _drawerMenuController.selectedMenuItem,
            builder: (context, value, child) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  end: 12.0,
                  start: 12.0,
                  bottom: 12.0,
                  top:
                      12.0 + _drawerMenuController.sizePaddingVertical(context),
                ),
                child: RawScrollbar(
                  thickness: 5,
                  radius: const Radius.circular(20),
                  thumbColor: ColorPalettes.blueGrey.withOpacity(0.35),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  Modular.to.pushNamed('/setting/');
                                },
                              )
                            ],
                          ),
                        ),
                        ItemMenu(
                          selected: 0 == value,
                          text: 'Todas as notas',
                          icon: Icons.library_books_outlined,
                          onTap: () => onTapItemSelected(0),
                        ),
                        AnimatedBuilder(
                            animation:
                                _drawerMenuController.shared.reactiveNotes,
                            builder: (context, child) {
                              return ItemMenu(
                                selected: 1 == value,
                                text: 'Favotitos',
                                sizeIcon: 28,
                                icon: Icons.star_border_rounded,
                                trailing: Text(
                                  _drawerMenuController.shared.reactiveNotes
                                              .qtdFavorites !=
                                          0
                                      ? _drawerMenuController
                                          .shared.reactiveNotes.qtdFavorites
                                          .toString()
                                      : '',
                                  style: TextStyle(
                                    color: ColorPalettes.secondy,
                                  ),
                                ),
                                onTap: () => onTapItemSelected(1),
                              );
                            }),
                        ValueListenableBuilder<int>(
                          valueListenable: _drawerMenuController
                              .shared.reactiveFolders.deleted,
                          builder: (context, qtd, child) {
                            return ItemMenu(
                              selected: 2 == value,
                              text: 'Lixeira',
                              sizeIcon: 28,
                              icon: Icons.delete_outline,
                              trailing: Text(
                                qtd != 0 ? qtd.toString() : '',
                                style: TextStyle(
                                  color: ColorPalettes.secondy,
                                ),
                              ),
                              onTap: () => onTapItemSelected(2),
                            );
                          },
                        ),
                        // ItemMenu(
                        //   text: 'Perfil',
                        //   icon: Icons.account_circle_outlined,
                        //   onTap: () async {
                        //     _drawerMenuController.closeDrawer();
                        //     await Future.delayed(
                        //       _drawerMenuController.duration,
                        //       () => Modular.to.pushNamed('/dashboard/perfil'),
                        //     );
                        //   },
                        // ),
                        Divider(color: Theme.of(context).backgroundColor),
                        // buildListFolders(),
                        AnimatedBuilder(
                          animation:
                              _drawerMenuController.shared.reactiveFolders,
                          builder: (context, child) {
                            return LadderFolder(
                              selected: value,
                              listFolders:
                                  _drawerMenuController.shared.listFolders,
                              onTapFolder: onTapItemFolder,
                            );
                          },
                        ),
                        //
                        const SizedBox(height: 6.0),
                        ButtonManageFolders(
                          onTap: () async {
                            _drawerMenuController.closeDrawer();
                            await Future.delayed(
                              _drawerMenuController.duration,
                              () => Modular.to
                                  .pushNamed('/dashboard/manager-folder/'),
                            );
                          },
                        ),
                        Divider(color: Theme.of(context).backgroundColor),
                        ItemMenu(
                          selected: 9999 == value,
                          text: 'Sair',
                          icon: Icons.exit_to_app_outlined,
                          onTap: () {
                            _drawerMenuController.selectedMenuItem.value = 9999;
                            _drawerController.logout(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
