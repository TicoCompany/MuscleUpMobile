// utils/util_enum.dart
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';

abstract class UtilEnum {
  static String getWorkoutTypeName(WorkoutTypeEnum type) {
    switch (type) {
      case WorkoutTypeEnum.A:
        return 'A';
      case WorkoutTypeEnum.B:
        return 'B';
      case WorkoutTypeEnum.C:
        return 'C';
      case WorkoutTypeEnum.D:
        return 'D';
      case WorkoutTypeEnum.E:
        return 'E';
      case WorkoutTypeEnum.F:
        return 'F';
      case WorkoutTypeEnum.G:
        return 'G';
      case WorkoutTypeEnum.AB:
        return 'AB';
      case WorkoutTypeEnum.ABC:
        return 'ABC';
      case WorkoutTypeEnum.ABCD:
        return 'ABCD';
      case WorkoutTypeEnum.ABCDE:
        return 'ABCDE';
      case WorkoutTypeEnum.ABCDEF:
        return 'ABCDEF';
      case WorkoutTypeEnum.ABCDEFG:
        return 'ABCDEFG';
    }
  }
}

