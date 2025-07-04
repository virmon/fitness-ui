import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';

extension MutableRoutine on Routine {
  Routine addExercise(Exercise newExercise) {
    final routineCopy = copyWith();
    final exerciseIndex = routineCopy.exercises
        .indexWhere((exercise) => exercise.id == newExercise.id);

    if (exerciseIndex != -1) {
      throw Exception('This exercise is already in ${routineCopy.title}');
    }

    return Routine(
      id: routineCopy.id,
      title: routineCopy.title,
      notes: routineCopy.notes,
      exercises: [...routineCopy.exercises, newExercise],
      isPrivate: routineCopy.isPrivate,
    );
  }

  Routine updateExercise(Exercise newExercise) {
    Routine routineCopy = copyWith();
    final exerciseIndex = routineCopy.exercises
        .indexWhere((exercise) => exercise.id == newExercise.id);

    if (exerciseIndex != -1) {}

    Exercise currentExercise = routineCopy.exercises[exerciseIndex];
    final updatedExercise = Exercise(
      id: currentExercise.id,
      title: currentExercise.title,
      type: currentExercise.type,
      exerciseSets: newExercise.exerciseSets,
    );

    routineCopy.exercises
        .replaceRange(exerciseIndex, exerciseIndex + 1, [updatedExercise]);

    return Routine(
      id: routineCopy.id,
      title: routineCopy.title,
      notes: routineCopy.notes,
      exercises: routineCopy.exercises,
      isPrivate: routineCopy.isPrivate,
    );
  }

  Routine removeExerciseById(String exerciseId) {
    final routineCopy = copyWith();
    final exerciseIndex = routineCopy.exercises
        .indexWhere((exercise) => exercise.id == exerciseId);

    routineCopy.exercises.removeAt(exerciseIndex);
    return Routine(
      id: routineCopy.id,
      title: routineCopy.title,
      notes: routineCopy.notes,
      exercises: routineCopy.exercises,
      isPrivate: routineCopy.isPrivate,
    );
  }
}
