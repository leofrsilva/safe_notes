import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/style/styles.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

class PopupMoreButtonWidget extends StatelessWidget {
  final List<NoteModel> noteSelecteds;
  final Function(String)? onSelected;
  final List<String> listMoreButton;

  const PopupMoreButtonWidget({
    Key? key,
    this.onSelected,
    required this.listMoreButton,
    required this.noteSelecteds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, -75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      itemBuilder: (BuildContext context) {
        return listMoreButton.map<PopupMenuItem<String>>((item) {
          if (item == 'favoritos') {
            String title = '';
            int existFavorite = noteSelecteds.where((note) {
              return note.favorite == true;
            }).length;
            int notExistFavorite = noteSelecteds.where((note) {
              return note.favorite == false;
            }).length;

            if (existFavorite > 0 && notExistFavorite == 0) {
              title = 'Remover dos $item';
            } else {
              title = 'Adicionar aos $item';
            }
            return PopupMenuItem<String>(
              value: item,
              child: Text(title),
            );
          }
          return PopupMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      child: ClipRRect(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.more_vert,
                color: ColorPalettes.black,
              ),
              const SizedBox(height: 5.0),
              Text(
                'Mais',
                style: TextStyle(
                  fontSize: 12.0,
                  color: ColorPalettes.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
