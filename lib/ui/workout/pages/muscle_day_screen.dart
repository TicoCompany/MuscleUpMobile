import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

class MuscleDayPage extends StatelessWidget {
  final List<MuscleDayEntity> muscleDays;

  const MuscleDayPage({super.key, required this.muscleDays});

  @override
  Widget build(BuildContext context) {
    final workoutType = muscleDays.isNotEmpty ? muscleDays[0].type.name : '';

    return Scaffold(
      appBar: AppBar(title: Text('Treino $workoutType')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: muscleDays.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final muscleDay = muscleDays[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                muscleDay.muscleGroup.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...muscleDay.exercises.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      textStyle: const TextStyle(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteGeneratorHelper.kExerciseDetails,
                        arguments: e,
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(e.name),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
