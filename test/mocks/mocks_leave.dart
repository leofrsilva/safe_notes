import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/shared/leave/domain/errors/leave_failures.dart';
import 'package:safe_notes/app/shared/leave/leave.dart';

class LeaveDatasourceMock extends Mock implements LeaveDatasource {}

class LeaveRepositoryMock extends Mock implements LeaveRepository {}

class LeaveFirestoreErrorMock extends Mock implements LeaveFirestoreError {}
