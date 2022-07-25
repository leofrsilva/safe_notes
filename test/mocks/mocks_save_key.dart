import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/domain/errors/register_key_failure.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/domain/repositories/i_save_key_repository.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/infra/datasources/i_save_key_datasource.dart';

class SaveKeyDatasourceMock extends Mock implements ISaveKeyDatasource {}

class SaveKeyRepositoryMock extends Mock implements ISaveKeyRepository {}

class SaveKeyFirestoreErrorMock extends Mock implements SaveKeyFirestoreError {}
