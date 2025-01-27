import 'dart:async';

import 'package:appflowy/user/application/auth/backend_auth_service.dart';
import 'package:appflowy/user/application/auth/auth_service.dart';
import 'package:appflowy/user/application/user_service.dart';
import 'package:appflowy_backend/dispatch/dispatch.dart';
import 'package:appflowy_backend/log.dart';
import 'package:appflowy_backend/protobuf/flowy-error/errors.pb.dart';
import 'package:appflowy_backend/protobuf/flowy-user/protobuf.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_error.dart';

/// Only used for testing.
class SupabaseMockAuthService implements AuthService {
  SupabaseMockAuthService();
  static OauthSignInPB? signInPayload;

  SupabaseClient get _client => Supabase.instance.client;
  GoTrueClient get _auth => _client.auth;

  final BackendAuthService _appFlowyAuthService =
      BackendAuthService(AuthenticatorPB.Supabase);

  @override
  Future<Either<FlowyError, UserProfilePB>> signUp({
    required String name,
    required String email,
    required String password,
    Map<String, String> params = const {},
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<FlowyError, UserProfilePB>> signInWithEmailPassword({
    required String email,
    required String password,
    Map<String, String> params = const {},
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<FlowyError, UserProfilePB>> signUpWithOAuth({
    required String platform,
    Map<String, String> params = const {},
  }) async {
    const password = "AppFlowyTest123!";
    const email = "supabase_integration_test@appflowy.io";
    try {
      if (_auth.currentSession == null) {
        try {
          await _auth.signInWithPassword(
            password: password,
            email: email,
          );
        } catch (e) {
          Log.error(e);
          return Left(AuthError.supabaseSignUpError);
        }
      }
      // Check if the user is already logged in.
      final session = _auth.currentSession!;
      final uuid = session.user.id;

      // Create the OAuth sign-in payload.
      final payload = OauthSignInPB(
        authType: AuthenticatorPB.Supabase,
        map: {
          AuthServiceMapKeys.uuid: uuid,
          AuthServiceMapKeys.email: email,
          AuthServiceMapKeys.deviceId: 'MockDeviceId',
        },
      );

      // Send the sign-in event and handle the response.
      return UserEventOauthSignIn(payload).send().then((value) => value.swap());
    } on AuthException catch (e) {
      Log.error(e);
      return Left(AuthError.supabaseSignInError);
    }
  }

  @override
  Future<void> signOut() async {
    // await _auth.signOut();
    await _appFlowyAuthService.signOut();
  }

  @override
  Future<Either<FlowyError, UserProfilePB>> signUpAsGuest({
    Map<String, String> params = const {},
  }) async {
    // supabase don't support guest login.
    // so, just forward to our backend.
    return _appFlowyAuthService.signUpAsGuest();
  }

  @override
  Future<Either<FlowyError, UserProfilePB>> signInWithMagicLink({
    required String email,
    Map<String, String> params = const {},
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<FlowyError, UserProfilePB>> getUser() async {
    return UserBackendService.getCurrentUserProfile();
  }
}
