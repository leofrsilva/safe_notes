import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../../shared/database/views/folder_qtd_child_view.dart';
import '../../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../../presenter/reactive/i_reactive_list_folder.dart';
import '../manager_folders_controller.dart';

class EditNamePage extends StatefulWidget {
  final FolderQtdChildView folderQtdChildView;

  const EditNamePage({
    Key? key,
    required this.folderQtdChildView,
  }) : super(key: key);

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  late TextEditingController _textEditingFolder;
  late IReactiveListFolder _reactiveListFolder;
  late ManagerFoldersController _controller;
  late GlobalKey<FormState> _formKey;
  late FocusNode _focusNode;

  FolderModel folder = FolderModel.empty();

  double bottomPadding = 0.0;
  bool canAdd = false;

  String? validatorName(String? name) {
    if (name != null) {
      var folderQtdChildView = widget.folderQtdChildView.copyWith(name: name);
      if (_reactiveListFolder.checkNameAlreadyExists(folderQtdChildView)) {
        return 'Já existe uma pasta com esse nome.';
      }
    }
    return null;
  }

  toggleFocus() async {
    if (FocusScope.of(context).focusedChild == _focusNode) {
      if (_focusNode.hasFocus) {
        bottomPadding = 12.0;
      } else {
        bottomPadding = 0.0;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ManagerFoldersController>();
    _reactiveListFolder =
        Modular.get<DrawerMenuController>().shared.reactiveFolders;
    folder = folder.copyWith(
      folderId: widget.folderQtdChildView.id,
      userId: _controller.userUId,
      name: widget.folderQtdChildView.name,
      level: widget.folderQtdChildView.level,
      color: widget.folderQtdChildView.color,
      folderParent: widget.folderQtdChildView.parentId,
    );
    _textEditingFolder = TextEditingController(text: folder.name);

    _formKey = GlobalKey<FormState>();
    _focusNode = FocusNode();
    _focusNode.addListener(toggleFocus);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textEditingFolder.dispose();
    _focusNode.removeListener(toggleFocus);
    _focusNode.dispose();
    super.dispose();
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
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 8.0,
                      ),
                      margin: EdgeInsets.only(bottom: bottomPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextFieldWithHint(
                              controller: _textEditingFolder,
                              title: 'Renomear a Pasta',
                              hint: 'Nome da Pasta',
                              focusNode: _focusNode,
                              validator: validatorName,
                              onChanged: (String name) {
                                setState(() {
                                  if (name.isEmpty) {
                                    canAdd = false;
                                  } else if (name.isNotEmpty) {
                                    if (name ==
                                        widget.folderQtdChildView.name) {
                                      canAdd = false;
                                    } else if (name.length > 1) {
                                      canAdd = true;
                                    }
                                    folder = folder.copyWith(name: name.trim());
                                  }
                                });
                                final formState = _formKey.currentState;
                                if (formState != null) {
                                  if (formState.validate()) {
                                    setState(() => canAdd = true);
                                  } else {
                                    setState(() => canAdd = false);
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 15.0),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
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
                                        horizontal: 8.0,
                                        vertical: 5.0,
                                      ),
                                      child: Text(
                                        'Renomear',
                                        style: TextStyles.textButton(context)
                                            .copyWith(
                                          color: canAdd
                                              ? Theme.of(context).primaryColor
                                              : ColorPalettes.grey,
                                        ),
                                      ),
                                    ),
                                    onPressed: canAdd
                                        ? () {
                                            folder = folder.copyWith(
                                              dateModification: DateTime.now(),
                                            );
                                            _controller.editFolder(
                                                context, folder);
                                            Modular.to.pop();
                                          }
                                        : null,
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
