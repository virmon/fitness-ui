# Creating a Domain/Data Model

### Main objectives of Domain Layer:
  1. Data encapsulation
  3. Data serialization/deserialization

The main objective of the Data Model is to serve as a model or blueprint of data for the app. It will also be used to serialize/deserialize the data in the [Repository Layer](./data_repository_layer.md). The model should have a method to easily convert from JSON data to Data Model, and Data Model to JSON.

### Code Generation tools to create Data Model
  - https://app.quicktype.io/

### Example of a Data Model:
```dart
// routines/domain/exercise_set.dart

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

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => {...}

  Map<String, dynamic> toJson() => {...}
}

```