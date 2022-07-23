import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/repositories/i_getin_firebase_repository.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_getin_firebase_datasource.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/errors/signup_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/repositories/i_signup_firebase_repository.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/infra/datasources/i_signup_firebase_datasource.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

class FirebaseFirestoreMock extends Mock implements FirebaseFirestore {}

final userAuthMock = MockUser(
  isAnonymous: false,
  uid: 'testuid',
  displayName: 'Test',
  email: 'test@somedomain.com',
);

class FirebaseAuthMock extends Mock implements FirebaseAuth {
  @override
  Future<void> signOut() async {}
}

class NoUserCredentialMock extends Mock implements UserCredential {
  @override
  User? get user => null;
}

class UserCredentialMock extends Mock implements UserCredential {
  @override
  User? get user => userAuthMock;
}

//
class GetinFirebaseDatasourceMock extends Mock
    implements IGetinFirebaseDatasource {}

class GetinFirebaseRepositoryMock extends Mock
    implements IGetinFirebaseRepository {}

//
class SignupFirebaseDatasourceMock extends Mock
    implements ISignupFirebaseDatasource {}

class RightSignupFirebaseDatasourceMock extends Mock
    implements ISignupFirebaseDatasource {
  @override
  Future<dynamic> insertUserFirestore(UsuarioModel model) async {
    return dynamic;
  }
}

class LeftSignupFirebaseDatasourceMock extends Mock
    implements ISignupFirebaseDatasource {
  final Failure? failure;
  LeftSignupFirebaseDatasourceMock({this.failure});

  @override
  Future<dynamic> insertUserFirestore(UsuarioModel model) async {
    throw failure ?? SignupFirestoreErrorMock();
  }
}

class SignupFirebaseRepositoryMock extends Mock
    implements ISignupFirebaseRepository {}

//Error
//-----
class CreateUserAuthFirebaseErrorMock extends Mock
    implements CreateUserAuthFirebaseError {}

class SignupFirestoreErrorMock extends Mock implements SignupFirestoreError {}

class LoginAuthFirebaseErrorMock extends Mock
    implements LoginAuthFirebaseError {}

class GetinFirestoreErrorMock extends Mock implements GetinFirestoreError {}
//-----

//Exception
//-----
class FirebaseAuthExceptionMock extends FirebaseAuthException with Mock {
  FirebaseAuthExceptionMock({required String code}) : super(code: code);
}
