import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class ILeaveRepository {
  Future<Either<Failure, dynamic>> leaveAuth();
}
