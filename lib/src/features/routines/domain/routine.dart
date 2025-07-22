import 'dart:convert';

import 'package:fitness_ui/src/features/routines/domain/exercise.dart';

List<Routine> routineFromJson(String str) =>
    List<Routine>.from(json.decode(str).map((x) => Routine.fromJson(x)));

String routineToJson(List<Routine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Routine {
  final String? id;
  final String title;
  final String? notes;
  final List<Exercise> exercises;
  final bool isPrivate;
  final String? createdAt;
  final String? updatedAt;

  const Routine({
    this.id,
    required this.title,
    this.notes,
    this.exercises = const [],
    this.isPrivate = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json["routine_uid"],
      title: json["title"],
      notes: json["notes"],
      exercises: List<Exercise>.from(
          json["exercises"].map((exercise) => Exercise.fromJson(exercise))),
      isPrivate: json["is_private"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "routine_uid": id,
        "title": title,
        "notes": notes,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
        "is_private": isPrivate,
      };

  Routine copyWith({
    String? id,
    String? title,
    String? notes,
    List<Exercise>? exercises,
    bool? isPrivate,
  }) =>
      Routine(
        id: id ?? this.id,
        title: title ?? this.title,
        notes: notes ?? this.notes,
        exercises: exercises ?? this.exercises,
        isPrivate: isPrivate ?? this.isPrivate,
      );
}
