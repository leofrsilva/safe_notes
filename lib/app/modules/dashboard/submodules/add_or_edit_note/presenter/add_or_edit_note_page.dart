import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/design/widgets/textfield/custom_textfield_title_note.dart';

import 'add_or_edit_note_controller.dart';
import 'enum/mode_note_enum.dart';

class AddOrEditNotePage extends StatefulWidget {
  final ModeNoteEnum mode;

  final NoteModel note;
  final FolderQtdChildView folder;

  const AddOrEditNotePage({
    Key? key,
    required this.mode,
    required this.note,
    required this.folder,
  }) : super(key: key);

  @override
  State<AddOrEditNotePage> createState() => _AddOrEditNotePageState();
}

class _AddOrEditNotePageState extends State<AddOrEditNotePage> {
  late AddOrEditNoteController _controller;

  bool _isExpanded = false;
  late FocusNode _focusNode;

  void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != _isExpanded) {
      setState(() {
        _isExpanded = shouldBeExpanded;
      });
    }
  }

  void toggleExpansion() {
    _setExpansion(!_isExpanded);
  }

  Widget? infoNote;

  initialConfig() {
    var infoFolder = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_outlined,
          color: Color(widget.folder.color),
        ),
        const SizedBox(width: 6.0),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            widget.folder.name,
            style: TextStyles.cardTitleFolder,
          ),
        ),
      ],
    );
    if (widget.mode == ModeNoteEnum.edit) {
      infoNote = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoFolder,
          const SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Última modificação: ' +
                    widget.note.dateModification.toStrDateTime,
                style: TextStyle(
                  fontSize: 11,
                  color: ColorPalettes.grey,
                ),
              ),
              const SizedBox(height: 1.0),
              Text(
                'Criado: ' + widget.note.dateCreate.toStrDate,
                style: TextStyle(
                  fontSize: 11,
                  color: ColorPalettes.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      );
    } else {
      infoNote = infoFolder;
    }
  }

  @override
  void initState() {
    super.initState();
    initialConfig();
    _focusNode = FocusNode()..requestFocus();
    _controller = Modular.get<AddOrEditNoteController>();

    _controller.noteModel = widget.note;
    _controller.folderId = widget.folder.id;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.mode == ModeNoteEnum.add) {
          if (_controller.alreadySaved) {
            await _controller.delete();
          }
        }
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Sizes.heightStatusBar(context),
              ),
              child: CustomTextFieldTitleNote(
                heightExpanded: widget.mode == ModeNoteEnum.add ? 135.0 : 160.0,
                expanded: _isExpanded,
                childDetails: infoNote,
                onChanged: (text) {
                  _controller.onChangedTitle(context, text);
                },
                onTapTextField: () {
                  if (!_isExpanded) {
                    toggleExpansion();
                  }
                },
                onTapIcon: () {
                  if (_isExpanded) {
                    toggleExpansion();
                    _focusNode.requestFocus();
                  } else {
                    Modular.to.pop();
                  }
                },
              ),
            ),
            Container(
              height: Sizes.height(context) * 0.4,
              child: RawScrollbar(
                thickness: 5,
                radius: const Radius.circular(20),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: TextField(
                            focusNode: _focusNode,
                            maxLines: 500,
                            // maxLines: Sizes.height(context).toInt(),
                            // maxLength: 500,
                            onChanged: (text) {
                              _controller.onChangedBody(context, text);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              // filled: true,
                              // fillColor: Colors.black12,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_isExpanded)
                          ModalBarrier(
                            dismissible: true,
                            color: Colors.black12,
                            onDismiss: () {
                              toggleExpansion();
                              _focusNode.requestFocus();
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetAddTitle(BuildContext context) {
    return CustomTextFieldTitleNote(
      // heightExpanded: widget.mode == ModeNoteEnum.add ? 135.0 : 155.0,
      heightExpanded: 135.0,
      expanded: _isExpanded,
      childDetails: infoNote,
      onChanged: (text) {
        _controller.onChangedTitle(context, text);
      },
      onTapTextField: () {
        if (!_isExpanded) {
          toggleExpansion();
        }
      },
      onTapIcon: () {
        if (_isExpanded) {
          toggleExpansion();
          _focusNode.requestFocus();
        } else {
          Modular.to.pop();
        }
      },
    );
  }

  Widget widgetEditTitle(BuildContext context) {
    return CustomTextFieldTitleNote(
      heightExpanded: 155.0,
      // initialValue: ,
      expanded: _isExpanded,
      childDetails: infoNote,
      onChanged: (text) {
        _controller.onChangedTitle(context, text);
      },
      onTapTextField: () {
        if (!_isExpanded) {
          toggleExpansion();
        }
      },
      onTapIcon: () {
        if (_isExpanded) {
          toggleExpansion();
          _focusNode.requestFocus();
        } else {
          Modular.to.pop();
        }
      },
    );
  }
}
