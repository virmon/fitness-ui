class ExerciseSet {
  final String setNo;
  final int repLower;
  final int repUpper;
  final int weight;
  final String weightUnit;
  final int restDuration;
  final List? reps;
  final int? rpe;

  const ExerciseSet({
    required this.setNo,
    this.repLower = 8,
    this.repUpper = 8,
    required this.weight,
    this.weightUnit = 'LBS',
    this.restDuration = 0,
    this.reps = const [],
    this.rpe = 0,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
        setNo: json["set_no"].toString(),
        weight: 0,
        reps: json["reps"] ?? [],
        rpe: json["rpe"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "set_no": int.parse(setNo),
        "weight": weight,
        "reps:": reps,
        "rpe": rpe,
      };
}
