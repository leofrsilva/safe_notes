import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../presenter/reactive/i_reactive_list.dart';
import '../manager_folders_controller.dart';
import '../widgets/grid_selection_color.dart';

class AddFolderPage extends StatefulWidget {
  final IReactiveList reactiveList;
  final FolderModel folderModel;

  const AddFolderPage({
    Key? key,
    required this.reactiveList,
    required this.folderModel,
  }) : super(key: key);

  @override
  State<AddFolderPage> createState() => _AddFolderPageState();
}

class _AddFolderPageState extends State<AddFolderPage> {
  late IReactiveList _reactiveList;
  late TextEditingController _textEditingFolder;
  late ManagerFoldersController _controller;
  late GlobalKey<FormState> _formKey;
  late FocusNode _focusNode;

  FolderModel folder = FolderModel.empty();

  double bottomPadding = 0.0;
  bool canAdd = true;

  toggleCanAdd(bool value) {
    if (value != canAdd) {
      setState(() => canAdd = value);
    }
  }

  String? validatorName(String? name) {
    if (name != null) {
      var folderModel = widget.folderModel.copyWith(
        level: widget.folderModel.level + 1,
        folderParent: widget.folderModel.folderId,
      );
      if (_reactiveList.checkNameAlreadyExists(
        folderModel,
        _textEditingFolder.text,
      )) {
        return 'Já existe uma pasta com esse nome.';
      }
    }
    return null;
  }

  String _generateDefaultNameFolder() {
    int qtd = _reactiveList.qtdNameFolder(
      widget.folderModel.folderId,
      widget.folderModel.level + 1,
    );
    var name = 'Pasta ' + qtd.toString();
    return name;
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
    _reactiveList = widget.reactiveList;

    var fieldName = _generateDefaultNameFolder();
    folder = folder.copyWith(
      name: fieldName,
      userId: _controller.userUId,
      color: DefaultDatabase.colorFolderDefault,
      level: widget.folderModel.level + 1,
      folderParent: widget.folderModel.folderId,
    );
    _textEditingFolder = TextEditingController(text: fieldName);

    _formKey = GlobalKey<FormState>();
    _focusNode = FocusNode();
    _focusNode.addListener(toggleFocus);
    WidgetsBinding.instance?.addPostFrameCallback((timings) {
      if (Sizes.orientation(context) == Orientation.portrait) {
        _focusNode.requestFocus();
      }
    });
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
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: 330.0,
                      padding: const EdgeInsets.only(
                        top: 25.0,
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextFieldWithHint(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _textEditingFolder,
                                title: 'Criar Pasta',
                                hint: 'Nome da Pasta',
                                focusNode: _focusNode,
                                validator: validatorName,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30),
                                ],
                                onChanged: (String name) {
                                  if (name.isEmpty) {
                                    toggleCanAdd(false);
                                  } else if (name.isNotEmpty) {
                                    if (name.length == 1) toggleCanAdd(true);
                                  }
                                  //
                                  final formState = _formKey.currentState;
                                  if (formState != null) {
                                    if (formState.validate()) {
                                      toggleCanAdd(true);
                                    } else {
                                      toggleCanAdd(false);
                                    }
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: GridSelectionColor(
                                  onChangeColor: (int color) {
                                    folder = folder.copyWith(color: color);
                                  },
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 5.0,
                                        ),
                                        child: Text(
                                          'Adicionar',
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
                                                name: _textEditingFolder.text,
                                                dateCreate: DateTime.now(),
                                                dateModification:
                                                    DateTime.now(),
                                              );
                                              _controller.addFolder(
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
