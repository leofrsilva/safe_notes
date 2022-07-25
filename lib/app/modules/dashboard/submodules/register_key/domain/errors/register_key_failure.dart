import 'package:safe_notes/app/shared/errors/failure.dart';

class SaveKeyFirestoreError extends Failure {
  SaveKeyFirestoreError(
    String label,
    dynamic exception,
    String errorMessage,
  ) : super(
          label: label,
          exception: exception,
          errorMessage: errorMessage,
        );
}
