import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/domain/errors/register_key_failure.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/infra/repositories/save_key_repository.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../../../../../../mocks/mocks_save_key.dart';
import '../../../../../../../stub/usuario_entity_stub.dart';

void main() {
  var keyText = 'val1';
  UsuarioModel user = UsuarioModel.fromEntity(user0);

  final datasource = SaveKeyDatasourceMock();

  group('save key repository saveKey | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.saveKey(user, keyText))
          .thenAnswer((_) async => dynamic);

      final repository = SaveKeyRepository(datasource);
      final result = await repository.saveKey(user, keyText);

      expect(result.isRight(), equals(true));
    });

    test('retornar um SaveKeyFirestoreError', () async {
      when(() => datasource.saveKey(user, keyText))
          .thenThrow(SaveKeyFirestoreErrorMock());

      final repository = SaveKeyRepository(datasource);
      final result = await repository.saveKey(user, keyText);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<SaveKeyFirestoreError>());
    });
  });
}
