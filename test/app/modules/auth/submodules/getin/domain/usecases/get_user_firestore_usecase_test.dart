import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/usecases/get_user_firestore_usecase.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

import '../../../../../../../mocks/mocks.dart';
import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  final entity = UsuarioEntityMock();
  final repository = GetinFirebaseRepositoryMock();

  test(
      'user firebase usecase GetUserFirestoreUsecase.Call | retorna um UsuarioEntity',
      () async {
    String docRef = 'docRef';

    when(() => repository.getUserFirestore(docRef)).thenAnswer(
      (_) async => Right(entity),
    );

    final usecase = GetUserFirestoreUsecase(repository);
    final result = await usecase.call(docRef);

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<UsuarioEntity>());
  });

  test(
      'user firebase usecase GetUserFirestoreUsecase.Call | retornar um GetinFirestoreError',
      () async {
    String docRef = 'docRef';

    when(() => repository.getUserFirestore(docRef))
        .thenAnswer((_) async => Left(GetinFirestoreErrorMock()));

    final usecase = GetUserFirestoreUsecase(repository);
    final result = await usecase.call(docRef);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<GetinFirestoreError>());
  });

  test(
      'user firebase usecase GetUserFirestoreUsecase.Call | retornar um GetinNoDataFoundFirestoreError',
      () async {
    String docRef = 'docRef';

    when(() => repository.getUserFirestore(docRef))
        .thenAnswer((_) async => Left(GetinNoDataFoundFirestoreError()));

    final usecase = GetUserFirestoreUsecase(repository);
    final result = await usecase.call(docRef);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<GetinNoDataFoundFirestoreError>());
  });
}
