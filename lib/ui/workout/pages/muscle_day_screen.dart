import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';

class MuscleDayPage extends StatelessWidget {
  final MuscleDayEntity muscleDay;
  const MuscleDayPage({super.key, required this.muscleDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dia ${muscleDay.type.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              muscleDay.muscleGroup.name, // ou .toLabel se você tiver extensão personalizada
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
        ),
      ),
    );
  }
}
