import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge_ai/features/auth/domain/entities/user_entity.dart';
import 'package:edubridge_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:edubridge_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edubridge_ai/features/auth/presentation/bloc/auth_state.dart';

/// Minimal [AuthRepository] fake that lets a test control what
/// `authStateChanges` reports, standing in for "Firebase does/doesn't have
/// a cached session" without touching real Firebase. Every other member is
/// unused by [AuthBloc]'s startup path, so they just throw if called.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._authStateChanges);

  final Stream<UserEntity?> _authStateChanges;

  @override
  Stream<UserEntity?> get authStateChanges => _authStateChanges;

  @override
  UserEntity? get currentUser => throw UnimplementedError();

  @override
  bool get isEmailVerified => throw UnimplementedError();

  @override
  Future<void> reloadUser() => throw UnimplementedError();

  @override
  Future<UserEntity?> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      throw UnimplementedError();

  @override
  Future<void> sendEmailVerification() => throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();
}

final _cachedUser = UserEntity(
  id: 'uid-123',
  email: 'student@alu.education',
  fullName: 'Neville Iregi',
  role: 'student',
  bio: 'Aspiring engineer',
  profilePictureUrl: '',
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

void main() {
  group('AuthBloc session persistence on startup', () {
    // AuthBloc fires AppStarted from its own constructor, so simply
    // building the bloc is enough to exercise the startup check — there's
    // no event to dispatch from `act`.
    blocTest<AuthBloc, AuthState>(
      'emits AuthAuthenticated when Firebase already has a cached session',
      build: () => AuthBloc(_FakeAuthRepository(Stream.value(_cachedUser))),
      expect: () => [AuthAuthenticated(_cachedUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthUnauthenticated when there is no cached session',
      build: () => AuthBloc(_FakeAuthRepository(Stream.value(null))),
      expect: () => [AuthUnauthenticated()],
    );
  });
}
