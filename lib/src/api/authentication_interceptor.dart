import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitness_ui/src/features/authentication/authentication_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationInterceptor extends InterceptorsWrapper {
  final Function retry;
  Ref ref;

  AuthenticationInterceptor({
    required this.ref,
    required this.retry,
  });

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      String? token =
          await ref.read(authStateNotifierProvider.notifier).getToken();
      log('[ACCESS_TOKEN] $token');
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
      String? newAccessToken = await Future.value(
          'refresh-token'); // fetch your token from some other source
      if (newAccessToken != null) {
        try {
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          // todo: implement a way to retrieve a refresh token
          handler.resolve(await retry(err.requestOptions));
        } on DioException catch (e) {
          handler.next(e);
        }
      }
      return;
    }
    super.onError(err, handler);
  }
}
