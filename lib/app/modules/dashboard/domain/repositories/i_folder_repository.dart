import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

abstract class IFolderRepository {
  Future<Either<Failure, dynamic>> addFolders(List<FolderModel> folders);
  Future<Either<Failure, dynamic>> editFolder(FolderModel folder);
  Future<Either<Failure, dynamic>> deleteFolder(List<FolderModel> folders);
  Future<Either<Failure, dynamic>> restoreFolder(List<FolderModel> folders);
  Future<Either<Failure, dynamic>> deletePersistentFolder(
      List<FolderModel> folders);
}
