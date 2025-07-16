import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitness_ui/src/features/authentication/authentication_notifier.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationInterceptor extends InterceptorsWrapper {
  Ref ref;

  AuthenticationInterceptor({
    required this.ref,
  });

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      String? token =
          await ref.read(authStateNotifierProvider.notifier).getToken();
      if (token != null) {
        final headers = {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        };
        options.headers.addAll(headers);
        return super.onRequest(options, handler);
      } else {
        throw Exception('Missing access token');
      }
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      String? newIdToken =
          await ref.read(authRepositoryProvider).getNewIdToken();
      if (newIdToken != null) {
        try {
          ref.read(authStateNotifierProvider.notifier).setToken(newIdToken);
          err.requestOptions.headers['Authorization'] = 'Bearer $newIdToken';
          handler.resolve(await retryRequest(err.requestOptions));
        } on DioException catch (e) {
          handler.next(e);
        }
      }
      return;
    }
    super.onError(err, handler);
  }

  Future<Response> retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    return await dio.fetch(requestOptions);
  }
}
