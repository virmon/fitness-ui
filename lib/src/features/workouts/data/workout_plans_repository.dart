import 'package:fitness_ui/src/constants/mock_workout_plans.dart';
import 'package:fitness_ui/src/features/authentication/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_ui/src/features/workouts/domain/workout_plan.dart';

class WorkoutPlansRepository {
  WorkoutPlansRepository();

  // todo: replace with API
  final List<WorkoutPlan> _workoutPlans = mockWorkoutPlans;

  Future<bool> createWorkoutPlanById(
      {required WorkoutPlan newWorkoutPlan}) async {
    await Future.delayed(const Duration(seconds: 2));
    // todo: integrate CREATE ONE from API
    return true;
  }

  Future<List<WorkoutPlan?>> getWorkoutPlans() async {
    // todo: integrate GET ALL from API
    await Future.delayed(const Duration(seconds: 2));
    // return throw Exception('Could not fetch data');
    return Future.value(_workoutPlans);
  }

  Future<WorkoutPlan?> getWorkoutPlanById(
      {required String workoutPlanId}) async {
    // todo: integrate GET ONE BY ID from API
    await Future.delayed(const Duration(seconds: 2));
    final workoutPlan =
        _workoutPlans.where((plans) => plans.id == workoutPlanId);
    return Future.value(workoutPlan.single);
  }

  Stream<List<WorkoutPlan>> watchWorkoutPlanList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _workoutPlans;
  }

  Stream<WorkoutPlan?> watchWorkoutPlan(String id) {
    return watchWorkoutPlanList().map((workoutPlans) =>
        workoutPlans.firstWhere((workoutPlan) => workoutPlan.id == id));
  }

  Future<bool> updateWorkoutPlanById(
      {required WorkoutPlan updatedWorkoutPlan}) async {
    await Future.delayed(const Duration(seconds: 2));
    // todo: integrate UPDATE from API
    return true;
  }

  Future<bool> deleteWorkoutPlanById({required String workoutPlanId}) async {
    await Future.delayed(const Duration(seconds: 2));
    // todo: integrate DELETE from API
    return true;
  }
}

final workoutPlansRepositoryProvider = Provider<WorkoutPlansRepository>((ref) {
  return WorkoutPlansRepository();
});

final workoutPlanListFutureProvider =
    FutureProvider.autoDispose<List<WorkoutPlan?>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching workout plans');
  }
  final workoutPlansRepository = ref.read(workoutPlansRepositoryProvider);
  return workoutPlansRepository.getWorkoutPlans();
});

final workoutPlanFutureProvider = StreamProvider.autoDispose
    .family<WorkoutPlan?, String>((ref, workoutPlanId) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching workout plans');
  }
  final workoutPlansRepository = ref.watch(workoutPlansRepositoryProvider);
  return workoutPlansRepository.watchWorkoutPlan(workoutPlanId);
});
