import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class ISetFolderRepository {
  Future<Either<Failure, dynamic>> setDefaultFolder(String uid);
}
