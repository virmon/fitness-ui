import 'package:fitness_ui/src/constants/mock_routines.dart';
import 'package:fitness_ui/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutinesRepository {
  RoutinesRepository();

  // todo: replace with API
  final List<Routine> _routines = mockRoutines;

  Future<bool> createRoutineById({required Routine newRoutine}) async {
    await Future.delayed(const Duration(seconds: 2));
    // todo: integrate CREATE ONE from API
    return true;
  }

  Future<List<Routine?>> getRoutines() async {
    // todo: integrate GET ALL from API
    await Future.delayed(const Duration(seconds: 2));
    // return throw Exception('Could not fetch data');
    return Future.value(_routines);
  }

  Future<Routine?> getRoutineById({required String routineId}) async {
    // todo: integrate GET ONE BY ID from API
    await Future.delayed(const Duration(seconds: 2));
    final routine = _routines.where((plans) => plans.id == routineId);
    return Future.value(routine.single);
  }

  Stream<List<Routine>> watchRoutineList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _routines;
  }

  Stream<Routine?> watchRoutine(String id) {
    return watchRoutineList()
        .map((routines) => routines.firstWhere((routine) => routine.id == id));
  }

  Future<bool> updateRoutineById({required Routine updatedRoutine}) async {
    await Future.delayed(const Duration(seconds: 2));
    // todo: integrate UPDATE from API
    return true;
  }

  Future<bool> deleteRoutineById({required String routineId}) async {
    await Future.delayed(const Duration(seconds: 2));
    // todo: integrate DELETE from API
    return true;
  }
}

final routinesRepositoryProvider = Provider<RoutinesRepository>((ref) {
  return RoutinesRepository();
});

final routineListFutureProvider =
    FutureProvider.autoDispose<List<Routine?>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching routines');
  }
  final routinesRepository = ref.read(routinesRepositoryProvider);
  return routinesRepository.getRoutines();
});

final routineFutureProvider =
    StreamProvider.autoDispose.family<Routine?, String>((ref, routineId) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching routines');
  }
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.watchRoutine(routineId);
});
