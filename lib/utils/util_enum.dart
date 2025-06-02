// utils/util_enum.dart
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';

abstract class UtilEnum {
  static String getWorkoutTypeName(WorkoutTypeEnum type) {
    switch (type) {
      case WorkoutTypeEnum.A:
        return 'Treino A';
      case WorkoutTypeEnum.B:
        return 'Treino B';
      case WorkoutTypeEnum.C:
        return 'Treino C';
      default:
        return 'Desconhecido';
    }
  }
}
