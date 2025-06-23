import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';

class Exercise {
  final String id;
  final String title;
  final String description;
  final String type;
  final String notes;
  final List<ExerciseSet> exerciseSets;

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.notes,
    required this.exerciseSets,
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
        "exercise_sets":
            List<dynamic>.from(exerciseSets.map((x) => x.toJson())),
      };
}
