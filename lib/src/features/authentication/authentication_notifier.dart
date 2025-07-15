import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthState {
  final String? accessToken;
  final String? refreshToken;
  final bool isAuthenticated;

  AuthState(
      {this.accessToken, this.refreshToken, this.isAuthenticated = false});
}

class AuthenticationNotifier extends StateNotifier<AuthState> {
  final secureStorage = FlutterSecureStorage();

  AuthenticationNotifier(Ref ref) : super(AuthState()) {
    _loadTokens(secureStorage);
  }

  Future<void> _loadTokens(FlutterSecureStorage secureStorage) async {
    // Load tokens from secure storage (e.g., KeyStore on Android, Keychain on iOS)
    final accessToken = await secureStorage.read(key: 'accessToken');
    final refreshToken = await secureStorage.read(key: 'refreshToken');

    if (accessToken != null && refreshToken != null) {
      state = AuthState(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAuthenticated: true);
    }
  }

  FlutterSecureStorage getSecureStorage() {
    return secureStorage;
  }

  Future<String?> getToken() async {
    try {
      String? token = await secureStorage.read(key: 'accessToken');
      return token;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  void setToken(String token) async {
    try {
      await secureStorage.write(key: 'accessToken', value: token);
    } catch (e) {
      log(e.toString());
    }
  }

  void clearToken() async {
    log('clearToken()');
    try {
      await secureStorage.delete(key: 'accessToken');
    } catch (e) {
      log(e.toString());
    }
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthState>((ref) {
  return AuthenticationNotifier(ref);
});
