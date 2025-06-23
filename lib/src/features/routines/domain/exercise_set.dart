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
