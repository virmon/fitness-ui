import 'dart:convert';
import 'dart:developer';

import 'package:fitness_ui/src/features/authentication/domain/app_user.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AppUserRepository {
  AppUserRepository(this.ref);
  Ref ref;

  Future<AppUser> signUp(credentials) async {
    try {
      var client = http.Client();

      final response = await client.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD94eU8H_OzN77HSylWwsSyoNMm-RpQESI'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': credentials['email'],
          "password": credentials['password'],
          "returnSecureToken": credentials['returnSecureToken'],
        }),
      );
      log(response.body);
      return AppUser.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } finally {
      log('New user successfully created');
    }
  }

  Future<AppUser> signIn(credentials) async {
    try {
      var client = http.Client();

      final response = await client.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD94eU8H_OzN77HSylWwsSyoNMm-RpQESI'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': credentials['email'],
          "password": credentials['password'],
          "returnSecureToken": credentials['returnSecureToken'],
        }),
      );
      return AppUser.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (error, _) {
      try {
        return await signUp(credentials);
        // todo: upon successful signup, error was thrown
        // return await Future.error(credentials);
      } catch (error) {
        // log(error.toString());
        await ref.read(authRepositoryProvider).signOut();
        throw Exception('Sign-up error');
      }
    }
  }
}

final appUserRepositoryProvider = Provider<AppUserRepository>((ref) {
  return AppUserRepository(ref);
});

final signInProvider = FutureProvider.autoDispose
    .family<AppUser, Map<String, dynamic>>((ref, user) {
  return ref.watch(appUserRepositoryProvider).signIn(user);
});
