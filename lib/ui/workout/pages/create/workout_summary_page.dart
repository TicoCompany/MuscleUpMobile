import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final WorkoutCreateViewModel viewModel;

  const WorkoutSummaryPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Treino')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Nome do Treino: ${viewModel.workoutName}'),
            const SizedBox(height: 16),
            Text('Tipo de Treino: ${viewModel.workoutType?.name}'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.muscleDays.length,
                itemBuilder: (context, index) {
                  final muscleDay = viewModel.muscleDays[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dia ${muscleDay.type.name} - ${muscleDay.muscleGroup.name}',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ...muscleDay.exercises.map((exercise) {
                            return ListTile(
                              title: Text(exercise.name),
                              subtitle: Text('Séries: ${exercise.sets}, Reps: ${exercise.reps}'),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode enviar o treino para o backend ou concluir
              },
              child: const Text('Confirmar Treino'),
            ),
          ],
        ),
      ),
    );
  }
}
