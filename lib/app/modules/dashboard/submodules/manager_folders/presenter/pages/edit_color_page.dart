import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../../shared/database/views/folder_qtd_child_view.dart';
import '../manager_folders_controller.dart';
import '../widgets/grid_selection_color.dart';

class EditColorPage extends StatefulWidget {
  final FolderQtdChildView folderQtdChildView;

  const EditColorPage({
    Key? key,
    required this.folderQtdChildView,
  }) : super(key: key);

  @override
  State<EditColorPage> createState() => _EditColorPageState();
}

class _EditColorPageState extends State<EditColorPage> {
  late ManagerFoldersController _controller;

  FolderModel folder = FolderModel.empty();

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ManagerFoldersController>();
    folder = folder.copyWith(
      folderId: widget.folderQtdChildView.id,
      userId: _controller.userUId,
      name: widget.folderQtdChildView.name,
      level: widget.folderQtdChildView.level,
      color: widget.folderQtdChildView.color,
      folderParent: widget.folderQtdChildView.parentId,
    );
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      width: 330.0,
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: GridSelectionColor(
                                title: 'Alterar cor da pasta',
                                initalColor: folder.color,
                                onChangeColor: (int color) {
                                  folder = folder.copyWith(
                                    color: color,
                                    dateModification: DateTime.now(),
                                  );
                                  _controller.editFolder(context, folder);
                                  Modular.to.pop();
                                },
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextButton(
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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