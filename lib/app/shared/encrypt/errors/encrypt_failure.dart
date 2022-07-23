import 'package:safe_notes/app/shared/errors/failure.dart';

class IncorrectEncryptionError extends Failure {
  IncorrectEncryptionError({
    String? errorMessage,
    dynamic exception,
    StackTrace? stackTrace,
    String? label,
  }) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage: errorMessage ?? '',
        );
}
