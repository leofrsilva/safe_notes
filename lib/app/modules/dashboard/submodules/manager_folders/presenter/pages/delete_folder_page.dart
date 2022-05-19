import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../manager_folders_controller.dart';

// ignore: must_be_immutable
class DeleteFolderPage extends StatelessWidget {
  final List<FolderQtdChildView> listFolderQtdChildView;
  final _controller = Modular.get<ManagerFoldersController>();

  FolderModel folder = FolderModel.empty();

  DeleteFolderPage({
    Key? key,
    required this.listFolderQtdChildView,
  }) : super(key: key);

  confirmDelete(BuildContext context) {
    List<FolderModel> listModel =
        listFolderQtdChildView.map((folderQtdChildView) {
      return folder.copyWith(
        isDeleted: true,
        folderId: folderQtdChildView.id,
        userId: _controller.userUId,
        name: folderQtdChildView.name,
        level: folderQtdChildView.level,
        color: folderQtdChildView.color,
        folderParent: folderQtdChildView.parentId,
      );
    }).toList();

    if (listFolderQtdChildView.length == 1) {
      _controller.deleteFolder(context, listModel);
    }
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.transparent,
      body: SizedBox(
        height: Sizes.height(context),
        child: Stack(
          children: [
            SizedBox(
              height: Sizes.height(context) * 0.925,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ModalBarrier(
                    dismissible: true,
                    onDismiss: () {
                      Modular.to.pop();
                    },
                  ),
                  Container(
                    width: 330.0,
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Sizes.width(context),
                          padding:
                              const EdgeInsets.only(top: 5.0, bottom: 15.0),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyles.fieldStyle.copyWith(
                                color: ColorPalettes.blueGrey,
                              ),
                              text: 'Mover ${listFolderQtdChildView.length} ',
                              children: [
                                if (listFolderQtdChildView.length > 1)
                                  const TextSpan(text: 'pastas para a Lixeira?')
                                else
                                  const TextSpan(text: 'pasta para a Lixeira?'),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyles.textButton(context),
                                  ),
                                ),
                                onPressed: () {
                                  Modular.to.pop();
                                },
                              ),
                              Container(
                                width: 1.5,
                                height: 12.0,
                                color: ColorPalettes.blueGrey,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Mover para a Lixeira',
                                    style:
                                        TextStyles.textButton(context).copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  confirmDelete(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
