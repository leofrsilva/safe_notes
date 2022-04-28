import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/dashboard/infra/adapter/entity_to_model.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';

void main() {
  test('receber uma lista de FolderEntity e retornar uma lista de FolderModel',
      () {
    final entity = FolderEntityMock();
    final result = EntityToModel.fromListFolderEntity([entity]);
    expect(result, isA<List<FolderModel>>());
    expect(result.length, equals(1));
  });
}
