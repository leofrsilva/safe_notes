import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/repositories/i_leave_repository.dart';
import '../datasources/i_leave_datasource.dart';

class LeaveRepository extends ILeaveRepository {
  final ILeaveDatasource _leaveDatasource;
  LeaveRepository(this._leaveDatasource);

  @override
  Future<Either<Failure, dynamic>> leaveAuth() async {
    try {
      final result = await _leaveDatasource.leaveAuth();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'LeaveRepository-leaveAuth',
      ));
    }
  }
}
