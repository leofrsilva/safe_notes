import 'package:sqlite3/sqlite3.dart';
import 'package:mocktail/mocktail.dart';

//
class SqliteExceptionMock extends SqliteException with Mock {
  SqliteExceptionMock() : super(0, '');
}
