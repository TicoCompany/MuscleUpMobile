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
            ...types.map((type) => ElevatedButton(
                 onPressed: () {
                  // Filtra a lista muscleDays para pegar **todos** os MuscleDayEntity com o tipo atual
                  final muscleDaysOfType = muscleDays.where((e) => e.type == type).toList();

                  Navigator.pushNamed(
                    context,
                    RouteGeneratorHelper.kMuscleDayDetails,
                    arguments: muscleDaysOfType, // <-- lista, não um único objeto
                  );
                },


                  child: Text('Dia $type'),
                )),
          ],
        ),
      ),
    );
  }
}