import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';


class WorkoutEntity {
  final int id;
  final String name;
  final workoutInfoTypeEnum type;
  final List<MuscleDayEntity> muscleDays;

  const WorkoutEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.muscleDays,
  });

  factory WorkoutEntity.fromMap(Map<String, dynamic> map) {
    return WorkoutEntity(
      id: map['id'],
      name: map['name'],
      type: workoutInfoTypeEnum.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => workoutInfoTypeEnum.A,
      ),
      muscleDays:
          (map['muscleDays'] as List)
              .map((e) => MuscleDayEntity.fromMap(e))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'muscleDays': muscleDays.map((e) => e.toMap()).toList(),
    };
  }
}
