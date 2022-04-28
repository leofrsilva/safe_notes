import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class ISetFolderUsecase {
  Future<Either<Failure, dynamic>> call(String uid);
}
