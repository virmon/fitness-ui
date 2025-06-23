import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';

const mockRoutines = [
  Routine(
    id: '1',
    title: 'My First Workout Plan',
    notes: '',
    exercises: [
      Exercise(
          id: '1',
          title: 'Squats',
          description: 'desc1',
          type: 'Weights',
          notes: '',
          exerciseSets: [
            ExerciseSet(
                setNo: '1',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
            ExerciseSet(
                setNo: '2',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
            ExerciseSet(
                setNo: '3',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
          ]),
      Exercise(
          id: '2',
          title: 'Squats with Barbell',
          description: 'desc1',
          type: 'Weights',
          notes: '',
          exerciseSets: [
            ExerciseSet(
                setNo: '1',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
            ExerciseSet(
                setNo: '2',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
          ]),
      Exercise(
          id: '3',
          title: 'Leg-raises',
          description: 'desc1',
          type: 'Weights',
          notes: '',
          exerciseSets: [
            ExerciseSet(
                setNo: '1',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
            ExerciseSet(
                setNo: '2',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
          ]),
    ],
    isPrivate: false,
  ),
  Routine(
    id: '2',
    title: 'My Awesome plan',
    notes: '',
    exercises: [
      Exercise(
          id: '1',
          title: 'Sit-ups',
          description: 'desc1',
          type: 'Weights',
          notes: '',
          exerciseSets: [
            ExerciseSet(
                setNo: '1',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
            ExerciseSet(
                setNo: '2',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
          ]),
    ],
    isPrivate: false,
  ),
  Routine(
    id: '3',
    title: 'My Leg Day Plan',
    notes: '',
    exercises: [
      Exercise(
          id: '1',
          title: 'Squats',
          description: 'desc1',
          type: 'Weights',
          notes: '',
          exerciseSets: [
            ExerciseSet(
                setNo: '1',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
            ExerciseSet(
                setNo: '2',
                repLower: 5,
                repUpper: 10,
                weight: 20,
                weightUnit: 'LBS',
                restDuration: 2000),
          ]),
    ],
    isPrivate: false,
  ),
];
