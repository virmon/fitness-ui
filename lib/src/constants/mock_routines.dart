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

const mockExercises = [
  Exercise(id: '1', title: 'Squats', type: 'Legs'),
  Exercise(id: '2', title: 'Push-ups', type: 'Chest'),
  Exercise(id: '3', title: 'Sit-ups', type: 'Core'),
  Exercise(id: '4', title: 'Crunches', type: 'Core'),
  Exercise(id: '5', title: 'Pull-ups', type: 'Back'),
  Exercise(id: '6', title: 'Lunges', type: 'Legs'),
  Exercise(id: '7', title: 'Bicep Curls', type: 'Arms'),
  Exercise(id: '8', title: 'Deadlifts', type: 'Legs'),
  Exercise(id: '9', title: 'Burpees', type: 'Core'),
  Exercise(id: '10', title: 'Leg Raise', type: 'Legs'),
  Exercise(id: '11', title: 'Shoulder Press', type: 'Shoulders'),
  Exercise(id: '12', title: 'Bulgarian Split Squats', type: 'Legs'),
];
