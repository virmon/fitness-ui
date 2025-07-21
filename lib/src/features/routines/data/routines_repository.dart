import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitness_ui/src/api/api_client.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutinesRepository {
  RoutinesRepository(this.ref);
  Ref ref;

  final routinesEndpoint = '/api/routines/';

  final _cachedRoutines = InMemoryStore<List<Routine>>([]);

  Future<List<Routine?>> getRoutines() async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.get('${routinesEndpoint}me');
      final fetchedData = response.data as List;
      List<Routine>? routines = List<Routine>.from(
          fetchedData.map((routine) => Routine.fromJson(routine)));
      return Future.value(routines);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<Routine?>> getPublicRoutines() async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.get(routinesEndpoint);
      final fetchedData = response.data as List;
      List<Routine>? routines = List<Routine>.from(
          fetchedData.map((routine) => Routine.fromJson(routine)));
      return Future.value(routines);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<List<Routine>> watchRoutinesList() {
    return _cachedRoutines.stream;
  }

  Stream<Routine?> watchRoutine(String routineId) {
    return watchRoutinesList()
        .map((routines) => _getRoutine(routines, routineId));
  }

  Future<Routine?> getRoutineById(String routineId) async {
    final client = ref.read(dioProvider);
    final response = await client.get(routinesEndpoint + routineId);
    final routine = Routine.fromJson(response.data);

    return Future.value(routine);
    // return _getRoutine(_cachedRoutines.value, routineId);
  }

  static Routine? _getRoutine(List<Routine> routines, String routineId) {
    try {
      return routines.firstWhere((routine) => routine.id == routineId);
    } catch (e) {
      return null;
    }
  }

  void _updateRoutineById(Routine routine) async {
    // todo: integrate update a routine
    final client = ref.read(dioProvider);
    final response = await client.put('$routinesEndpoint${routine.id}');
    log('update this routine ${routine.id}');
    log('[update response] ${response.data}');
  }

  Future<Routine?> addRoutine(Routine routine) async {
    try {
      if (routine.id == null) {
        final client = ref.read(dioProvider);
        final response =
            await client.post('/api/routines/', data: routine.toJson());
        log('Add Response');
        log('!!! ${response.data.toString()}');
        return Routine.fromJson(response.data);
      } else {
        _updateRoutineById(routine);
        return null;
      }
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<bool> deleteRoutineById({required String routineId}) async {
    try {
      final client = ref.read(dioProvider);
      final response = await client.delete('$routinesEndpoint$routineId');
      log(response.data.toString());
      return true;
    } on DioException catch (e) {
      throw Exception('${e.message}');
    } catch (e) {
      throw Exception('Could not delete the routine. Please try again.');
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
  // return routinesRepository.watchRoutine(id);
  return routinesRepository.getRoutineById(id);
});
