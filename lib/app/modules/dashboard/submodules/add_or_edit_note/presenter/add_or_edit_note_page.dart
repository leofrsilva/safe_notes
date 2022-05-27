import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController? _editingControllerBody;
  late TextEditingController _editingControllerTitle;
  late AddOrEditNoteController _controller;
  late FocusNode _focusNodeBody;
  
  bool isVisibleFloatingButton = false;
  toggleVisibleFloatingButton(bool value) {
    if (isVisibleFloatingButton != value) {
      setState(() => isVisibleFloatingButton = value);
    }
  }
  
  late ScrollController scrollController;
  checkScrollInTop() {
    if (scrollController.offset > 2) {
      toggleVisibleFloatingButton(true);
    } else {
      toggleVisibleFloatingButton(false);
    }
  }

  int _maxLines = 0;
  bool _isExpanded = false;
  bool isFocusBody(BuildContext context) {
    return FocusScope.of(context).focusedChild == _focusNodeBody;
  }

  void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != _isExpanded) {
      setState(() {
        _isExpanded = shouldBeExpanded;
        genterateDetails();
      });
    }
  }

  void _toggleExpansion() {
    _setExpansion(!_isExpanded);
  }

  void removeFocusTitle() {
    _toggleExpansion();
    _focusNodeBody.requestFocus();
  }

  Widget? infoNote;

  genterateDetails() {
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
                    _controller.noteModel.dateModification.toStrDateTime,
                style: TextStyle(
                  fontSize: 11,
                  color: ColorPalettes.grey,
                ),
              ),
              const SizedBox(height: 1.0),
              Text(
                'Criado: ' + _controller.noteModel.dateCreate.toStrDate,
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
    _focusNodeBody = FocusNode();
    _controller = Modular.get<AddOrEditNoteController>();

    _controller.mode = widget.mode;
    _controller.noteModel = widget.note;
    _controller.folderId = widget.folder.id;
    if (widget.mode == ModeNoteEnum.edit) {
      _editingControllerTitle = TextEditingController(
        text: widget.note.title,
      );
      _editingControllerBody = TextEditingController(
        text: widget.note.body,
      );
    } else {
      _editingControllerTitle = TextEditingController();
      _focusNodeBody.requestFocus();
    }
    genterateDetails();
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
    _maxLines = (_maxLines * 0.05).toInt();
    _maxLines += (Sizes.heightKeyboard(context) > 0 ? -1 : 2);

    return WillPopScope(
      onWillPop: () async {
        if (_isExpanded) {
          removeFocusTitle();
          return false;
        } else {
          if (isFocusBody(context)) {
            _focusNodeBody.unfocus();
            return false;
          }
        }
        if (widget.mode == ModeNoteEnum.add) {
          await _controller.delete();
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
                    //! isAlwaysShown: isFocusBody(context) ? true : false,
                    thumbColor: ColorPalettes.secondy,
                    radius: const Radius.circular(20),
                    child: TextField(
                      controller: _editingControllerBody,
                      focusNode: _focusNodeBody,
                      maxLines: _maxLines,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4903),
                      ],
                      onChanged: (text) {
                        _controller.onChangedBody(context, text);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // SizedBox(height: Sizes.heightKeyboard(context))
                ],
              ),
            ),
            if (_isExpanded)
              GestureDetector(
                onTap: () {
                  removeFocusTitle();
                },
                child: Container(
                  color: ColorPalettes.black26,
                  width: Sizes.width(context),
                  height: Sizes.height(context) -
                      (50.0 + Sizes.heightStatusBar(context)),
                  margin: EdgeInsets.only(
                      top: 50.0 + Sizes.heightStatusBar(context)),
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Sizes.heightStatusBar(context),
                ),
                child: CustomTextFieldTitleNote(
                  initialFocus:
                      _controller.mode == ModeNoteEnum.add, //* SetState mode
                  isFavorite: _controller.noteModel.favorite,
                  controller: _editingControllerTitle,
                  heightNotExpanded: 50,
                  heightExpanded:
                      widget.mode == ModeNoteEnum.add ? 145.0 : 175.0,
                  expanded: _isExpanded,
                  childDetails: infoNote,
                  onChanged: (text) {
                    _controller.onChangedTitle(context, text);
                  },
                  onTapTextField: () {
                    if (!_isExpanded) {
                      _toggleExpansion();
                    }
                  },
                  onTapIcon: () async {
                    if (_isExpanded) {
                      removeFocusTitle();
                    } else {
                      if (widget.mode == ModeNoteEnum.add) {
                        await _controller.delete();
                      }
                      Modular.to.pop();
                    }
                  },
                  onTapFavorite: () {
                    setState(() => _controller.changeFavorite(context));
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingButtonForTop(
          isVisible: isVisibleFloatingButton,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
