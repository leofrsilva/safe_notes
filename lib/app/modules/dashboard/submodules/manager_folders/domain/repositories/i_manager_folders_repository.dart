import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IManagerFoldersRepository {
  Future<Either<Failure, dynamic>> addFolder(FolderModel folder);
  Future<Either<Failure, dynamic>> editFolder(FolderModel folder);
  Future<Either<Failure, dynamic>> deleteFolder(int folderId);
}
