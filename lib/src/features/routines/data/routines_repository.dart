import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitness_ui/src/api/api_client.dart';
import 'package:fitness_ui/src/api/api_constants.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutinesRepository {
  RoutinesRepository(this.ref);
  Ref ref;

  final errorRepositoryMessage = 'Something went wrong. Please try again.';

  Future<List<Routine?>> getRoutines() async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.get(ApiEndpoints.userRoutines);
      final fetchedData = response.data as List;
      List<Routine>? routines = List<Routine>.from(fetchedData.map((routine) {
        return Routine.fromJson(routine);
      }));
      return Future.value(routines);
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e) {
      log(e.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<List<Routine?>> getPublicRoutines() async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.get(ApiEndpoints.publicRoutines);
      final fetchedData = response.data as List;
      List<Routine>? routines = List<Routine>.from(
          fetchedData.map((routine) => Routine.fromJson(routine)));
      return Future.value(routines);
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e) {
      log(e.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<Routine?> getRoutineById(String routineId) async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.get(ApiEndpoints.userRoutines,
          queryParameters: {"routine_uid": routineId});
      final jsonResponseRoutine = response.data[0];
      final routine = Routine.fromJson(jsonResponseRoutine);
      return Future.value(routine);
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<Routine?> getPublicRoutineById(String routineId) async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.get(ApiEndpoints.publicRoutines,
          queryParameters: {"routine_uid": routineId});
      final jsonResponseRoutine = response.data[0];
      final routine = Routine.fromJson(jsonResponseRoutine);
      return Future.value(routine);
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<List<Routine?>> searchPublicRoutineByUsername(String username) async {
    try {
      Map<String, String> queryParameter = {};
      if (username.isNotEmpty) {
        queryParameter = {'username': username};
      }
      final client = ref.read(dioProvider);
      final response = await client.get(ApiEndpoints.publicRoutines,
          queryParameters: queryParameter);
      final fetchedData = response.data as List;
      List<Routine>? routines = List<Routine>.from(
          fetchedData.map((routine) => Routine.fromJson(routine)));
      return Future.value(routines);
    } on DioException catch (e) {
      String errorMessage = errorRepositoryMessage;
      if (e.response != null) {
        errorMessage = e.response?.statusMessage ?? errorRepositoryMessage;
      }
      throw errorMessage;
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<Routine?> _updateRoutineById(Routine routine) async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.put('${ApiEndpoints.routines}${routine.id}',
          data: routine.toJson());
      log('[update response] ${response.data}');
      return Future.value(routine);
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<Routine?> addRoutine(Routine routine) async {
    try {
      if (routine.id == null) {
        final client = ref.read(dioProvider);
        final response =
            await client.post(ApiEndpoints.routines, data: routine.toJson());
        return Routine.fromJson(response.data);
      } else {
        final updatedRoutine = _updateRoutineById(routine);
        return updatedRoutine;
      }
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception(errorRepositoryMessage);
    }
  }

  Future<bool> deleteRoutineById({required String routineId}) async {
    try {
      final client = ref.read(dioProvider);
      final response =
          await client.delete('${ApiEndpoints.routines}$routineId');
      log(response.data.toString());
      return true;
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e) {
      throw Exception(errorRepositoryMessage);
    }
  }
}

final routinesRepositoryProvider = Provider<RoutinesRepository>((ref) {
  return RoutinesRepository(ref);
});

final routinesListFutureProvider =
    FutureProvider.autoDispose<List<Routine?>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching routines');
  }
  final routinesRepository = ref.read(routinesRepositoryProvider);
  return routinesRepository.getRoutines();
});

final routinesPublicListFutureProvider =
    FutureProvider.autoDispose<List<Routine?>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching routines');
  }
  final routinesRepository = ref.read(routinesRepositoryProvider);
  return routinesRepository.getPublicRoutines();
});

final routineProvider =
    FutureProvider.autoDispose.family<Routine?, String>((ref, id) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.getRoutineById(id);
});

final publicRoutineProvider =
    FutureProvider.autoDispose.family<Routine?, String>((ref, id) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.getPublicRoutineById(id);
});

final routinesListSearchProvider = FutureProvider.autoDispose
    .family<List<Routine?>, String>((ref, query) async {
  final link = ref.keepAlive();
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.searchPublicRoutineByUsername(query);
});
