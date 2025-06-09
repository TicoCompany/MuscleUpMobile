import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/utils/util_enum.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';


class WorkoutDetailsPage extends StatelessWidget {
  final WorkoutEntity workout;
  const WorkoutDetailsPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final muscleDays = workout.muscleDays;
    final types = muscleDays.map((e) => e.type).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Treino ${UtilEnum.getWorkoutTypeName(workout.type)}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ...types.map(
  (type) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: ElevatedButton(
      onPressed: () {
        final muscleDaysOfType = muscleDays.where((e) => e.type == type).toList();

        Navigator.pushNamed(
          context,
          RouteGeneratorHelper.kMuscleDayDetails,
          arguments: muscleDaysOfType,
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        backgroundColor: const Color.fromARGB(255, 248, 244, 250), // roxinho suave
        foregroundColor: const Color.fromARGB(255, 0, 0, 0), // cor do texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // cantos menos arredondados
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      child: Text(
        'Dia ${UtilEnum.getWorkoutTypeName(type)}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}