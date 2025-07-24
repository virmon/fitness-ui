import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';

class Exercise {
  final String id;
  final String title;
  final String? description;
  final int? restTimeSecs;
  final String type;
  final String? notes;
  final List<ExerciseSet>? exerciseSets;
  final List<ExerciseSet>? sets;

  const Exercise({
    required this.id,
    required this.title,
    this.description = '',
    this.restTimeSecs = 0,
    this.type = '',
    this.notes = '',
    this.exerciseSets,
    this.sets,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["exercise_id"],
        title: json["title"],
        restTimeSecs: json["rest_time_secs"],
        notes: json["notes"],
        sets: List<ExerciseSet>.from(
            json["sets"].map((s) => ExerciseSet.fromJson(s))),
        exerciseSets: [],
      );

  Map<String, dynamic> toJson() => {
        "exercise_id": id,
        "title": title,
        "rest_time_secs": restTimeSecs,
        "notes": notes,
        "sets": sets != null
            ? List<dynamic>.from(sets!.map((x) => x.toJson()))
            : [],
      };

  Exercise copyWith({
    String? id,
    String? title,
    String? description,
    int? restTimeSecs,
    String? type,
    String? notes,
    List<ExerciseSet>? exerciseSets,
    List<ExerciseSet>? sets,
  }) =>
      Exercise(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        restTimeSecs: restTimeSecs ?? this.restTimeSecs,
        type: type ?? this.type,
        notes: notes ?? this.notes,
        exerciseSets: exerciseSets ?? this.exerciseSets,
        sets: sets ?? this.sets,
      );
}
