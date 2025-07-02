import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';

class Exercise {
  final String id;
  final String title;
  final String? description;
  final String type;
  final String? notes;
  final List<ExerciseSet>? exerciseSets;

  const Exercise({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.notes,
    this.exerciseSets,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        notes: json["notes"],
        exerciseSets: List<ExerciseSet>.from(
            json["exercise_sets"].map((x) => ExerciseSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "type": type,
        "notes": notes,
        "exercise_sets": exerciseSets != null
            ? List<dynamic>.from(exerciseSets!.map((x) => x.toJson()))
            : [],
      };

  Exercise copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? notes,
    List<ExerciseSet>? exerciseSets,
  }) =>
      Exercise(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        notes: notes ?? this.notes,
        exerciseSets: exerciseSets ?? this.exerciseSets,
      );
}
