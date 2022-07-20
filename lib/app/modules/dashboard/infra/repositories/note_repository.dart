import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../domain/repositories/i_note_repository.dart';
import '../datasources/i_note_datasource.dart';

class NoteRepository extends INoteRepository {
  final INoteDatasource _datasource;
  NoteRepository(this._datasource);

  @override
  Future<Either<Failure, dynamic>> addNote(NoteModel note) async {
    try {
      final result = await _datasource.addNote(note.entity);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'NoteRepository-addNote',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> editNote(List<NoteModel> notes) async {
    try {
      final result = await _datasource.editNote(
        notes.map((note) => note.entity).toList(),
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'NoteRepository-editNote',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteNote(List<NoteModel> notes) async {
    try {
      final entities = notes
          .map((note) => note
              .copyWith(
                isDeleted: true,
                dateDeletion: DateTime.now(),
              )
              .entity)
          .toList();
      final result = await _datasource.deleteNote(entities);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'NoteRepository-deleteNote',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> restoreNote(List<NoteModel> notes) async {
    try {
      final entities =
          notes.map((note) => note.copyWith(isDeleted: false).entity).toList();
      final result = await _datasource.restoreNote(entities);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'NoteRepository-restoreNote',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deletePersistentNote(
      List<NoteModel> notes) async {
    try {
      final result = await _datasource.deletePersistentNote(
        notes.map((note) => note.entity).toList(),
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'NoteRepository-deletePersistentNote',
      ));
    }
  }
}
