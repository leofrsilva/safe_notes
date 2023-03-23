import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/floating_button/floating_button_for_top.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../presenter/enum/mode_enum.dart';
import 'add_or_edit_note_controller.dart';
import 'widgets/custom_textfield_title_note.dart';
import 'widgets/details_note_widget.dart';

class AddOrEditNotePage extends StatefulWidget {
  final ModeNoteEnum mode;

  final NoteModel note;
  final FolderModel folder;

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
  TextEditingController? _editingControllerBody;
  late TextEditingController _editingControllerTitle;
  late AddOrEditNoteController _controller;
  late ModeViewEnum _modeView;

  late FocusNode _focusNodeBody;
  late bool _isRequestFocus;

  noAllowRequestFocus() => _isRequestFocus = false;
  allowRequestFocus() => _isRequestFocus = true;

  int _maxLines = 0;
  bool isFocusBody(BuildContext context) {
    return FocusScope.of(context).focusedChild == _focusNodeBody;
  }

  void unFocusTitle() {
    _controller.expandedStore.toggleExpansion();
    // if (_isRequestFocus)  _focusNodeBody.requestFocus();
  }

  void unFocusBody() {
    _controller.scrollInTopStore.toggleVisibleFloatingButton(false);
    _focusNodeBody.unfocus();
    noAllowRequestFocus();
  }

  @override
  void initState() {
    super.initState();
    _focusNodeBody = FocusNode();
    _controller = Modular.get<AddOrEditNoteController>();

    _controller.mode = widget.mode;
    _controller.noteFields.model = widget.note;
    _controller.noteFields.folderId = widget.folder.folderId;

    if (widget.mode == ModeNoteEnum.edit) {
      noAllowRequestFocus();
      _modeView = ModeViewEnum.writing;
      _editingControllerTitle = TextEditingController(
        text: widget.note.title,
      );
      _editingControllerBody = TextEditingController(
        text: widget.note.body,
      );
    } else {
      allowRequestFocus();
      _modeView = ModeViewEnum.reading;
      _editingControllerTitle = TextEditingController();
      _focusNodeBody.requestFocus();
    }
  }

  @override
  void dispose() {
    _editingControllerTitle.dispose();
    _editingControllerBody?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _maxLines = (Sizes.height(context) - Sizes.heightKeyboard(context)).toInt();
    _maxLines = (_maxLines * 0.0525).toInt();
    _maxLines += (Sizes.heightKeyboard(context) > 0 ? -1 : 2);

    return WillPopScope(
      onWillPop: () async {
        //? Retract And Remove Focus Title
        if (_controller.expandedStore.expanded) {
          unFocusTitle();
          return false;
        }
        //? Remove Focus Body
        else {
          if (isFocusBody(context)) {
            unFocusBody();
            return false;
          }
        }
        //? Delete Note if is Empty
        if (widget.mode == ModeNoteEnum.add) {
          await _controller.delete(context);
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: Sizes.width(context),
              height: Sizes.height(context) -
                  (50.0 + Sizes.heightStatusBar(context)),
              margin: EdgeInsets.only(
                top: 50.0 + Sizes.heightStatusBar(context),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  RawScrollbar(
                    thickness: 8.0,
                    thumbColor:
                        Theme.of(context).colorScheme.outline.withOpacity(0.35),
                    radius: const Radius.circular(20),
                    child: TextField(
                      scrollController:
                          _controller.scrollInTopStore.scrollController,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _editingControllerBody,
                      focusNode: _focusNodeBody,
                      maxLines: _maxLines,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4903),
                      ],
                      onChanged: (text) {
                        _controller.changedBody(context, text);
                      },
                      onTap: () => allowRequestFocus(),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<bool>(
                valueListenable: _controller.expandedStore.isExpanded,
                builder: (context, expanded, child) {
                  if (expanded) {
                    return GestureDetector(
                      onTap: () => unFocusTitle(),
                      child: Container(
                        color: Colors.black45,
                        width: Sizes.width(context),
                        height: Sizes.height(context) -
                            (50.0 + Sizes.heightStatusBar(context)),
                        margin: EdgeInsets.only(
                            top: 50.0 + Sizes.heightStatusBar(context)),
                      ),
                    );
                  }
                  return Container();
                }),
            ValueListenableBuilder<bool>(
                valueListenable: _controller.expandedStore.isExpanded,
                builder: (context, expanded, child) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Sizes.heightStatusBar(context),
                      ),
                      child: CustomTextFieldTitleNote(
                        modeView: _modeView,
                        expanded: expanded,
                        initialFocus: _isRequestFocus,
                        isFavorite: _controller.noteFields.model.favorite,
                        controller: _editingControllerTitle,
                        heightNotExpanded: 50,
                        heightExpanded:
                            widget.mode == ModeNoteEnum.add ? 145.0 : 175.0,
                        childDetails: DetailsNoteWidget(
                          mode: widget.mode,
                          folder: widget.folder,
                          noteModel: _controller.noteFields.model,
                        ),
                        onPressedModelView: () {
                          if (_modeView == ModeViewEnum.writing) {
                            _focusNodeBody.requestFocus();
                            setState(() => _modeView = ModeViewEnum.reading);
                          } else {
                            if (_focusNodeBody.hasFocus) {
                              _focusNodeBody.unfocus();
                            } else {
                              setState(() => _modeView = ModeViewEnum.writing);
                            }
                          }
                        },
                        onChanged: (text) {
                          _controller.changedTitle(context, text);
                        },
                        onTapTextField: () {
                          if (!expanded) {
                            _controller.expandedStore.toggleExpansion();
                          }
                        },
                        onTapIcon: () async {
                          if (expanded) {
                            unFocusTitle();
                          } else {
                            if (isFocusBody(context)) {
                              unFocusBody();
                            } else {
                              if (widget.mode == ModeNoteEnum.add) {
                                await _controller.delete(context);
                              }
                              Modular.to.pop();
                            }
                          }
                        },
                        onTapFavorite: () {
                          setState(() => _controller.changeFavorite(context));
                        },
                      ),
                    ),
                  );
                }),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _controller.scrollInTopStore.isVisibleFloatingButton,
          builder: (context, value, child) {
            if (isFocusBody(context)) return Container();

            return FloatingButtonForTop(
              isVisible: value,
              scrollController: _controller.scrollInTopStore.scrollController,
            );
          },
        ),
      ),
    );
  }
}
