import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final ExerciseEntity exercise;

  const ExerciseDetailsPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: 'Nome', value: exercise.name),
            const SizedBox(height: 12),
            _InfoRow(label: 'Séries', value: '${exercise.sets}'),
            const SizedBox(height: 12),
            _InfoRow(label: 'Repetições', value: '${exercise.reps}'),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Carga',
              value: exercise.weight != null ? '${exercise.weight} kg' : '—',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Anotações',
              value: exercise.notes?.isNotEmpty == true ? exercise.notes! : '—',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
