import 'dart:convert';

List<WorkoutPlan> workoutPlanFromJson(String str) => List<WorkoutPlan>.from(
    json.decode(str).map((x) => WorkoutPlan.fromJson(x)));

String workoutPlanToJson(List<WorkoutPlan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkoutPlan {
  final String id;
  final String title;
  final String notes;
  final List<Exercise> exercises;
  final bool isPrivate;

  const WorkoutPlan({
    required this.id,
    required this.title,
    required this.notes,
    required this.exercises,
    required this.isPrivate,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
        id: json["id"],
        title: json["title"],
        notes: json["notes"],
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
        isPrivate: json["isPrivate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "notes": notes,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
        "isPrivate": isPrivate,
      };
}

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

class ExerciseSet {
  final String setNo;
  final int repLower;
  final int repUpper;
  final int weight;
  final String weightUnit;
  final int restDuration;

  const ExerciseSet({
    required this.setNo,
    required this.repLower,
    required this.repUpper,
    required this.weight,
    required this.weightUnit,
    required this.restDuration,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
        setNo: json["set_no"],
        repLower: json["rep_lower"],
        repUpper: json["rep_upper"],
        weight: json["weight"],
        weightUnit: json["weight_unit:"],
        restDuration: json["rest_duration"],
      );

  Map<String, dynamic> toJson() => {
        "set_no": setNo,
        "rep_lower": repLower,
        "rep_upper": repUpper,
        "weight": weight,
        "weight_unit:": weightUnit,
        "rest_duration": restDuration,
      };
}
