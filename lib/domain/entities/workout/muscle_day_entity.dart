import 'dart:ffi';

import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';

class MuscleDayEntity {
  final Long id;
  final WorkoutTypeEnum type; // A, B, C, etc.
  final MuscleGroupEnum muscleGroup; // Peito, Costas, etc.
  final List<ExerciseEntity> exercises;

  const MuscleDayEntity({
    required this.id,
    required this.type,
    required this.muscleGroup,
    required this.exercises,
  });

  factory MuscleDayEntity.fromMap(Map<String, dynamic> map) {
    return MuscleDayEntity(
      id: map['id'] as Long,
      type: WorkoutTypeEnum.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => WorkoutTypeEnum.A, // Valor padrão ou erro, se preferir
      ),
      muscleGroup: MuscleGroupEnum.values.firstWhere(
        (e) => e.name == map['muscleGroup'],
        orElse: () => MuscleGroupEnum.peito,
      ),
      exercises:
          (map['exercises'] as List)
              .map((e) => ExerciseEntity.fromMap(e))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'muscleGroup': muscleGroup.name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }
}
