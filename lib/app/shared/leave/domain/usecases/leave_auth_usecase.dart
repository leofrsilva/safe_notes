import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../repositories/i_leave_repository.dart';
import 'i_leave_auth_usecase.dart';

class LeaveAuthUsecase extends ILeaveAuthUsecase {
  final ILeaveRepository _leaveRepository;
  LeaveAuthUsecase(this._leaveRepository);

  @override
  Future<Either<Failure, dynamic>> call() async {
    return await _leaveRepository.leaveAuth();
  }
}
