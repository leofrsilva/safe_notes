import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/usecases/update_logged_user_firestore_usecase.dart';

import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  const docRef = 'docRef';
  final repository = GetinFirebaseRepositoryMock();

  test(
      'user firebase usecase UpdateLoggedUserFirestoreUsecase.Call | isRight é igual a True',
      () async {
    when(() => repository.updateLoggedUserFirestore(docRef))
        .thenAnswer((_) async => const Right(dynamic));

    final usecase = UpdateLoggedUserFirestoreUsecase(repository);
    final result = await usecase.call(docRef);

    expect(result.isRight(), equals(true));
  });

  test(
      'user firebase usecase UpdateLoggedUserFirestoreUsecase.Call | retorna um GetinFirestoreError',
      () async {
    when(() => repository.updateLoggedUserFirestore(docRef))
        .thenAnswer((_) async => Left(GetinFirestoreErrorMock()));

    final usecase = UpdateLoggedUserFirestoreUsecase(repository);
    final result = await usecase.call(docRef);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<GetinFirestoreError>());
  });
}
