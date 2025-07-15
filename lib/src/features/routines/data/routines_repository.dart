import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitness_ui/src/api/api_client.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';
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
      _cachedRoutines.value = routines;
      return Future.value(_cachedRoutines.value);
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
      _cachedRoutines.value = routines;
      return Future.value(_cachedRoutines.value);
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

  Routine? getRoutineById(String routineId) {
    return _getRoutine(_cachedRoutines.value, routineId);
  }

  static Routine? _getRoutine(List<Routine> routines, String routineId) {
    try {
      return routines.firstWhere((routine) => routine.id == routineId);
    } catch (e) {
      return null;
    }
  }

  void _updateRoutineById(Routine routine) {
    // todo: integrate update a routine
    log('update this routine ${routine.id}');
  }

  Future<void> addRoutine(Routine? routine) async {
    try {
      if (routine?.id == null) {
        Routine myNewRoutine = Routine(
          id: routine!.title,
          title: routine.title,
          exercises: routine.exercises,
          isPrivate: true,
        );
        final client = ref.read(dioProvider);
        final response =
            await client.post('/api/routines/', data: routine.toJson());
        log(response.toString());
        final routines = _cachedRoutines.value;
        routines.add(myNewRoutine);
      } else {
        _updateRoutineById(routine!);
      }
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      throw Exception('Something went wrong. Please try again.');
    }
  }

  Future<bool> deleteRoutineById({required String routineId}) async {
    final routines = _cachedRoutines.value;
    routines.removeWhere((routine) => routine.id == routineId);
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
    StreamProvider.autoDispose.family<Routine?, String>((ref, id) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.watchRoutine(id);
});
