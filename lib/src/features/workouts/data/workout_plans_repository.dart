import 'package:fitness_ui/src/constants/mock_workout_plans.dart';
import 'package:fitness_ui/src/features/authentication/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_ui/src/features/workouts/domain/workout_plan.dart';

class WorkoutPlansRepository {
  WorkoutPlansRepository();

  final List<WorkoutPlan> _workoutPlans = mockWorkoutPlans;

  // CREATE addWorkoutPlan

  // GET ALL
  Future<List<WorkoutPlan?>> getWorkoutPlans() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_workoutPlans);
  }

  // GET ONE getWorkoutPlanById

  // UPDATE updateWorkoutPlanById

  // DELETE deleteWorkoutPlanById
}

final workoutPlansRepositoryProvider = Provider<WorkoutPlansRepository>((ref) {
  return WorkoutPlansRepository();
});

final workoutPlanListFutureProvider =
    FutureProvider.autoDispose<List<WorkoutPlan?>>((ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching workout plans');
  }
  final workoutPlansRepository = ref.read(workoutPlansRepositoryProvider);
  return workoutPlansRepository.getWorkoutPlans();
});
