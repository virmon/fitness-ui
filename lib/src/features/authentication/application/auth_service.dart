import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ui/src/features/authentication/authentication_notifier.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  AuthService(this.ref);
  Ref ref;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<String> _getIdToken(User? user) async {
    try {
      if (user != null) {
        final token = await user.getIdToken();
        final refreshToken = user.refreshToken;
        log(refreshToken.toString());
        return token!;
      } else {
        log('unable to get user');
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
    return '';
  }

  void _saveToken(String token) async {
    _isLoggedIn = true;
    ref.read(authStateNotifierProvider.notifier).setToken(token);
  }

  void _handleSignInError(error, st) async {
    log(error.toString());
  }

  void signIn() async {
    final Future<User?> Function() signInUser;
    if (kIsWeb) {
      signInUser = ref.read(authRepositoryProvider).signInWithGooglePopUp;
    } else {
      signInUser = ref.read(authRepositoryProvider).signInWithGoogle;
    }
    await signInUser()
        .then((user) => _getIdToken(user))
        .then((appUser) => _saveToken(appUser))
        .catchError(_handleSignInError);
  }

  void logout() async {
    await ref.read(authRepositoryProvider).signOut();
    _isLoggedIn = false;
    ref.read(authStateNotifierProvider.notifier).clearToken();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});
