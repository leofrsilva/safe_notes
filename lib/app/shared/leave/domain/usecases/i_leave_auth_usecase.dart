import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

abstract class ILeaveAuthUsecase {
  Future<Either<Failure, dynamic>> call();
}
