import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitness_ui/src/api/api_constants.dart';
import 'package:fitness_ui/src/api/authentication_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  final Dio client;

  ApiClient()
      : client = Dio(
          BaseOptions(
            sendTimeout: const Duration(milliseconds: 60000),
            receiveTimeout: const Duration(milliseconds: 60000),
            connectTimeout: const Duration(milliseconds: 60000),
            followRedirects: false,
            receiveDataWhenStatusError: true,
          ),
        );

  Future<Map<String, dynamic>?> get(
    String url, {
    Map<String, String>? queryParams = const {},
    Map<String, String>? headers = const {},
  }) async {
    try {
      final response = await client.get(url, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      log('Request failed: ${e.message}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> post(
    String url,
    dynamic payLoad, {
    Map<String, String>? headers = const {},
  }) async {
    try {
      final response = await client.post(url, data: payLoad);
      return response.data;
    } on DioException catch (e) {
      log('Request failed: ${e.message}');
      return null;
    }
  }
}

final apiClientProvider = Provider((ref) {
  return ApiClient();
});

final dioProvider = Provider<Dio>((ref) {
  final dio = ref.read(apiClientProvider).client;
  dio.options.baseUrl = Api.baseUrl;

  dio.interceptors.addAll([
    AuthenticationInterceptor(ref: ref),
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  ]);

  return dio;
});
