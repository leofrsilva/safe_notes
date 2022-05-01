import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IDeleteFolderRepository {
  Future<Either<Failure, dynamic>> deleteAllFolderExcept(int folderId);
}
