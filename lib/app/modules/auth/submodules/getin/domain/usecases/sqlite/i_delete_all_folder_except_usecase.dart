import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IDeleteAllFolderExceptUsecase {
  Future<Either<Failure, dynamic>> call(int folderId);
}
