// // database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'daos/folder_dao.dart';
import 'daos/note_dao.dart';
import 'daos/tag_dao.dart';
import 'entities/folder_entity.dart';
import 'entities/note_entity.dart';
import 'entities/tag_entity.dart';
import 'views/folder_qtd_child_view.dart';

part 'database.g.dart'; // the generated code will be there

@Database(
  version: 1,
  entities: [TagEntity, NoteEntity, FolderEntity],
  views: [FolderQtdChildView],
)
abstract class AppDatabase extends FloorDatabase {
  FolderDAO get folderDao;
  NoteDAO get noteDao;
  TagDAO get tagDao;
}
