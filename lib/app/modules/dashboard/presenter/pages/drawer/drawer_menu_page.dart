import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/menu/item_menu.dart';
import 'package:safe_notes/app/modules/dashboard/presenter/widgets/ladder_folder.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../dashboard_controller.dart';
import '../../../../../design/widgets/menu/button_manage_folders.dart';
import 'drawer_menu_controller.dart';
import 'stores/list_folders_store.dart';

class DrawerMenuPage extends StatefulWidget {
  const DrawerMenuPage({Key? key}) : super(key: key);

  @override
  State<DrawerMenuPage> createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {
  late ListFoldersStore listFoldersStore;
  late DashboardController drawerController;
  late DrawerMenuController drawerMenuController;

  onTapItemSelected(int index) async {
    drawerMenuController.selectedMenuItem.value = index;
    drawerMenuController.closeDrawer();
    await Future.delayed(
      drawerMenuController.duration,
      () {
        if (0 == index) {
          Modular.to.navigate('/dashboard/notes');
        } else if (1 == index) {
          Modular.to.navigate('/dashboard/favorites');
        } else if (2 == index) {
          Modular.to.navigate('/dashboard/lixeira');
        } else if (3 == index) {
          Modular.to.navigate('/dashboard/folders');
        }
      },
    );
  }

  Widget buildListFolders() {
    return ScopedBuilder<ListFoldersStore, Failure,
        Stream<List<FolderQtdChildView>>>.transition(
      store: listFoldersStore,
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    drawerController = Modular.get<DashboardController>();
    drawerMenuController = Modular.get<DrawerMenuController>();

    listFoldersStore = Modular.get<ListFoldersStore>();
    listFoldersStore.getListFolders(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: drawerMenuController.widthExpanded,
        height: Sizes.height(context),
        child: ValueListenableBuilder<int>(
            valueListenable: drawerMenuController.selectedMenuItem,
            builder: (context, value, child) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  end: 12.0,
                  start: 12.0,
                  bottom: 12.0,
                  top: 12.0 + drawerMenuController.sizePaddingVertical(context),
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
                        ItemMenu(
                          selected: 0 == value,
                          text: 'Todas as notas',
                          icon: Icons.library_books_outlined,
                          onTap: () => onTapItemSelected(0),
                        ),
                        ItemMenu(
                          selected: 1 == value,
                          text: 'Favotitos',
                          sizeIcon: 28,
                          icon: Icons.star_border_rounded,
                          onTap: () => onTapItemSelected(1),
                        ),
                        ItemMenu(
                          selected: 2 == value,
                          text: 'Lixeira',
                          sizeIcon: 28,
                          icon: Icons.delete_outline,
                          onTap: () => onTapItemSelected(2),
                        ),
                        // ItemMenu(
                        //   text: 'Perfil',
                        //   icon: Icons.account_circle_outlined,
                        //   onTap: () async {
                        //     drawerMenuController.closeDrawer();
                        //     await Future.delayed(
                        //       drawerMenuController.duration,
                        //       () => Modular.to.pushNamed('/dashboard/perfil'),
                        //     );
                        //   },
                        // ),
                        Divider(color: Theme.of(context).backgroundColor),
                        buildListFolders(),
                        const SizedBox(height: 6.0),
                        ButtonManageFolders(
                          onTap: () async {
                            drawerMenuController.closeDrawer();
                            await Future.delayed(
                              drawerMenuController.duration,
                              () => Modular.to
                                  .pushNamed('/dashboard/manager-folder'),
                            );
                          },
                        ),
                        Divider(color: Theme.of(context).backgroundColor),
                        ItemMenu(
                          selected: 9999 == value,
                          text: 'Sair',
                          icon: Icons.exit_to_app_outlined,
                          onTap: () {
                            drawerMenuController.selectedMenuItem.value = 9999;
                            drawerController.logout(context);
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
