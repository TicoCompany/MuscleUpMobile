import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';

class MuscleDayPage extends StatelessWidget {
  final List<MuscleDayEntity> muscleDays;

  const MuscleDayPage({super.key, required this.muscleDays});

  @override
  Widget build(BuildContext context) {
    // Supondo que todos muscleDays tenham o mesmo tipo (ex: A)
    final workoutType = muscleDays.isNotEmpty ? muscleDays[0].type.name : '';

    return Scaffold(
      appBar: AppBar(title: Text('Dia $workoutType')),
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
                muscleDay.muscleGroup.name, // nome do grupo muscular
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...muscleDay.exercises.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('- ${e.name}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
