import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/shared/leave/domain/errors/leave_failures.dart';
import 'package:safe_notes/app/shared/leave/infra/repositories/leave_repository.dart';

import '../../../../../mocks/mocks_leave.dart';

void main() {
  final datasource = LeaveDatasourceMock();

  group('leave repository leaveAuth |', () {
    test('isRight igual a True', () async {
      when(() => datasource.leaveAuth()).thenAnswer((_) async => dynamic);

      final repository = LeaveRepository(datasource);
      final result = await repository.leaveAuth();

      expect(result.isRight(), equals(true));
    });

    test('retornar um LeaveFirestoreError', () async {
      when(() => datasource.leaveAuth()).thenThrow(LeaveFirestoreErrorMock());

      final repository = LeaveRepository(datasource);
      final result = await repository.leaveAuth();

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<LeaveFirestoreError>());
    });
  });
}
