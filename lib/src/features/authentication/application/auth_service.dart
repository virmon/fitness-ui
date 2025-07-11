import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ui/src/features/authentication/data/app_user_repository.dart';
import 'package:fitness_ui/src/features/authentication/domain/app_user.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  AuthService(this.ref);
  Ref ref;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<AppUser> _signInAppUser(UserCredential signedInUser) async {
    try {
      if (signedInUser.user != null) {
        log('Sign in ${signedInUser.user!.email.toString()}');

        return await ref.read(signInProvider({
          'email': signedInUser.user!.email,
          'password': 'hellothere',
          'returnSecureToken': 'true',
        }).future);
      } else {
        log('Error: unable to retrieve user data');
        throw Exception('Error: unable to retrieve user data');
      }
    } on FirebaseAuthException catch (e, _) {
      log('FirebaseAuthException: ${e.message}');
      rethrow;
    }
  }

  void _storeAccessToken(appUser) {
    _isLoggedIn = true;
    // save token in app local store
    log('signed in as ${appUser.email}');
    log('token from API: ${appUser.idToken}');
  }

  void _handleSignInError(error, st) async {
    log(error.toString());
  }

  void signIn() async {
    await ref
        .read(authRepositoryProvider)
        .signInWithGoogle()
        .then((signedInUser) => _signInAppUser(signedInUser))
        .then((appUser) => _storeAccessToken(appUser))
        .catchError(_handleSignInError);
  }

  void logout() async {
    await ref.read(authRepositoryProvider).signOut();
    _isLoggedIn = false;
    // clear saved token
    log('clear token');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});
