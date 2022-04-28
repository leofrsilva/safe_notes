import 'package:safe_notes/app/shared/error/failure.dart';

class GetListFoldersSqliteError extends Failure {
  GetListFoldersSqliteError(
    StackTrace stackTrace,
    String label,
    dynamic exception,
    String errorMessage,
  ) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage: errorMessage,
        );
}
