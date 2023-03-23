import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/menu/item_menu.dart';
import 'package:safe_notes/app/modules/dashboard/presenter/widgets/ladder_folder.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../submodules/folder/folder_module.dart';
import '../../../submodules/folder/presenter/folder_controller.dart';
import '../../dashboard_controller.dart';
import '../../../../../design/widgets/menu/button_manage_folders.dart';
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

  onTapItemFolder(FolderModel folder) async {
    _drawerMenuController.closeDrawer();
    await Future.delayed(
      _drawerMenuController.duration,
      () async {
        Modular.to.navigate('/dashboard/mod-folder/');
        await Modular.isModuleReady<FolderModule>().then((_) async {
          await Future.delayed(
            _drawerMenuController.durationNavigateFolder,
            () {
              final controllerFolder = Modular.get<FolderController>();
              controllerFolder.folder = folder;
              // _drawerMenuController.moduleFolderSaveFolderParent(folder);
            },
          );
        });
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
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      body: ValueListenableBuilder<int>(
          valueListenable: _drawerMenuController.selectedMenuItem,
          builder: (context, value, child) {
            final paddingTop = Sizes.heightStatusBar(context);
            final height = Sizes.height(context) - paddingTop;
            return Container(
              height: height,
              width: _drawerMenuController.widthExpanded,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: paddingTop),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12.0,
                // top: Sizes.orientation(context) == Orientation.portrait
                //     ? 26.0
                //     : 0.0,
                // top: 12.0 + _drawerMenuController.sizePaddingVertical(context),
              ),
              child: SingleChildScrollView(
                padding: Sizes.orientation(context) == Orientation.portrait
                    ? const EdgeInsets.only(top: 30.0)
                    : null,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            onPressed: () => Modular.to.pushNamed('/setting/'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight:
                            Sizes.orientation(context) == Orientation.portrait
                                ? Sizes.height(context) * 0.70
                                : Sizes.height(context) * 0.55,
                      ),
                      child: RawScrollbar(
                        thickness: 5,
                        radius: const Radius.circular(20),
                        thumbColor: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.35),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedBuilder(
                                  animation: _drawerMenuController
                                      .listFieldsStore.reactive,
                                  builder: (context, child) {
                                    int qtd = _drawerMenuController
                                        .listFieldsStore.reactive.qtdNotes;
                                    return ItemMenu(
                                      selected: 0 == value,
                                      text: 'Todas as notas',
                                      icon: Icons.library_books_outlined,
                                      trailing: Text(
                                        qtd != 0 ? qtd.toString() : '',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ),
                                      onTap: () => onTapItemSelected(0),
                                    );
                                  }),
                              // FAVORITE
                              AnimatedBuilder(
                                animation: _drawerMenuController
                                    .listFieldsStore.reactive,
                                builder: (context, child) {
                                  Widget menuItem = Container();
                                  int qtd = _drawerMenuController
                                      .listFieldsStore.reactive.qtdFavorites;

                                  if (qtd != 0) {
                                    menuItem = ItemMenu(
                                      selected: 1 == value,
                                      text: 'Favotitos',
                                      sizeIcon: 28,
                                      icon: Icons.star_border_rounded,
                                      trailing: Text(
                                        qtd.toString(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ),
                                      onTap: () => onTapItemSelected(1),
                                    );
                                  }
                                  return menuItem;
                                },
                              ),
                              // DELETED
                              AnimatedBuilder(
                                  animation: _drawerMenuController
                                      .listFieldsStore.reactive,
                                  builder: (context, child) {
                                    int qtd = _drawerMenuController
                                        .listFieldsStore
                                        .reactive
                                        .numberItemsDeleted;
                                    return ItemMenu(
                                      selected: 2 == value,
                                      text: 'Lixeira',
                                      sizeIcon: 28,
                                      icon: Icons.delete_outline,
                                      trailing: Text(
                                        qtd != 0 ? qtd.toString() : '',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ),
                                      onTap: () => onTapItemSelected(2),
                                    );
                                  }),
                              //
                              const Divider(),
                              //
                              AnimatedBuilder(
                                animation: _drawerMenuController
                                    .listFieldsStore.reactive,
                                builder: (context, child) {
                                  return LadderFolder(
                                    selected: value,
                                    listFolders: _drawerMenuController
                                        .listFieldsStore.reactive.listFolder,
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
                                    () => Modular.to.pushNamed(
                                        '/dashboard/manager-folder/'),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    const Divider(),
                    //
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
            );
          }),
    );
  }
}
