// utils/util_enum.dart
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
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
    }
  }

  static String getWorkoutInfoTypeName(workoutInfoTypeEnum type) {
    switch (type) {
      case workoutInfoTypeEnum.A:
        return 'A';
      case workoutInfoTypeEnum.ab:
        return 'AB';
      case workoutInfoTypeEnum.abc:
        return 'ABC';
      case workoutInfoTypeEnum.abcd:
        return 'ABCD';
      case workoutInfoTypeEnum.abcde:
        return 'ABCDE';
      case workoutInfoTypeEnum.abcdef:
        return 'ABCDEF';
      case workoutInfoTypeEnum.abcdefg:
        return 'ABCDEFG';
    }
  }
}


