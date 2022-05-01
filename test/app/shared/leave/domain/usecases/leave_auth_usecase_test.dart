import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/shared/leave/domain/errors/leave_failures.dart';
import 'package:safe_notes/app/shared/leave/leave.dart';

import '../../../../../mocks/mocks_leave.dart';

void main() {
  final repository = LeaveRepositoryMock();

  test('leave auth usecase LeaveAuthUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.leaveAuth())
        .thenAnswer((invocation) async => const Right(dynamic));

    final usecase = LeaveAuthUsecase(repository);
    final result = await usecase.call();

    expect(result.isRight(), equals(true));
  });

  test(
      'leave auth usecase LeaveAuthUsecase.Call | retornar um LeaveFirestoreError',
      () async {
    when(() => repository.leaveAuth())
        .thenAnswer((invocation) async => Left(LeaveFirestoreErrorMock()));

    final usecase = LeaveAuthUsecase(repository);
    final result = await usecase.call();

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<LeaveFirestoreError>());
  });
}
