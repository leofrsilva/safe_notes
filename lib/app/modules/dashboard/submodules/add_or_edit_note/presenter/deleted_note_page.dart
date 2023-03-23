import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/floating_button/floating_button_for_top.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../presenter/enum/mode_enum.dart';
import 'deleted_note_controller.dart';
import 'widgets/custom_textfield_title_note.dart';

class DeletedNotePage extends StatefulWidget {
  final ModeNoteEnum mode;
  final NoteModel note;

  const DeletedNotePage({
    Key? key,
    required this.mode,
    required this.note,
  }) : super(key: key);

  @override
  State<DeletedNotePage> createState() => _DeletedNotePageState();
}

class _DeletedNotePageState extends State<DeletedNotePage> {
  late TextEditingController _editingControllerBody;
  late TextEditingController _editingControllerTitle;
  late DeletedNoteController _controller;

  int _maxLines = 0;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<DeletedNoteController>();

    _editingControllerTitle = TextEditingController(
      text: widget.note.title,
    );
    _editingControllerBody = TextEditingController(
      text: widget.note.body,
    );
  }

  @override
  void dispose() {
    _editingControllerTitle.dispose();
    _editingControllerBody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _maxLines = (Sizes.height(context) - Sizes.heightKeyboard(context)).toInt();
    _maxLines = (_maxLines * 0.0525).toInt();
    _maxLines += (Sizes.heightKeyboard(context) > 0 ? -1 : 2);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Sizes.width(context),
            height:
                Sizes.height(context) - (50.0 + Sizes.heightStatusBar(context)),
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
                    readOnly: true,
                    scrollController:
                        _controller.scrollInTopStore.scrollController,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _editingControllerBody,
                    maxLines: _maxLines,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4903),
                    ],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: Sizes.heightStatusBar(context),
              ),
              child: CustomTextFieldTitleNote(
                modeView: ModeViewEnum.reading,
                expanded: false,
                initialFocus: false,
                isFavorite: widget.note.favorite,
                controller: _editingControllerTitle,
                onTapIcon: () => Modular.to.pop(),
                widthActions: Sizes.width(context) * 0.3,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.replay_rounded),
                    onPressed: () {
                      _controller.restoreNotes(context, widget.note);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 12.0,
          ),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
            )),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Este conteúdo excluído em ${widget.note.deletionExpiration} dias.',
              )),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () {
                    _controller.deletePersistentNotes(
                      context,
                      widget.note,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _controller.scrollInTopStore.isVisibleFloatingButton,
        builder: (context, value, child) {
          return FloatingButtonForTop(
            isVisible: value,
            scrollController: _controller.scrollInTopStore.scrollController,
          );
        },
      ),
    );
  }
}
