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
  final List<Exercise>? exercises;
  final bool isPrivate;

  const Routine({
    this.id,
    required this.title,
    this.notes,
    this.exercises,
    required this.isPrivate,
  });

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
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
        "exercises": List<dynamic>.from(exercises!.map((x) => x.toJson())),
        "isPrivate": isPrivate,
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
