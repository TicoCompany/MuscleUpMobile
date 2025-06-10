import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final WorkoutCreateViewModel viewModel;

  const WorkoutSummaryPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutCreateViewModel>.value(
      value: viewModel,
      child: const _WorkoutSummaryScreenBody(),
    );
  }
}


class _WorkoutSummaryScreenBody extends StatefulWidget {
  const _WorkoutSummaryScreenBody();

  @override
  State<_WorkoutSummaryScreenBody> createState() =>
      _WorkoutSummaryScreenBodyState();
}

class _WorkoutSummaryScreenBodyState extends State<_WorkoutSummaryScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Treino')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Exibe o nome e tipo de treino
            Text('Nome do Treino: ${context.read<WorkoutCreateViewModel>().workoutName}'),
            const SizedBox(height: 16),
            Text('Tipo de Treino: ${context.read<WorkoutCreateViewModel>().workoutType?.name}'),
            const SizedBox(height: 16),
            // Exibe os grupos musculares com os exercícios
            Expanded(
              child: ListView.builder(
                itemCount: context.read<WorkoutCreateViewModel>().muscleDays.length,
                itemBuilder: (context, index) {
                  final muscleDay = context.read<WorkoutCreateViewModel>().muscleDays[index];
                  final selectedExercises = context.read<WorkoutCreateViewModel>()
                      .getSelectedExercisesForDayAndMuscleGroup(muscleDay.type, muscleDay.muscleGroup);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título do dia e grupo muscular
                          Text('Dia ${muscleDay.type.name} - ${muscleDay.muscleGroup.name}',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          // Exibe os exercícios
                          ...selectedExercises.map((exercise) {
                            return ListTile(
                              title: Text(exercise.name),
                              subtitle: Text('Séries: ${exercise.sets}, Reps: ${exercise.reps}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  // Alterna a seleção do exercício
                                  context.read<WorkoutCreateViewModel>().toggleExercise(muscleDay.type, muscleDay.muscleGroup, exercise);
                                },
                              ),
                            );
                          }).toList(),
                          // Botão para adicionar mais exercícios
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RouteGeneratorHelper.kWorkoutExercises,
                                arguments: {
                                  'viewModel': context.read<WorkoutCreateViewModel>(),
                                  'dayType': muscleDay.type,
                                  'muscleGroup': muscleDay.muscleGroup,
                                },
                              );
                            },
                            child: const Text('Adicionar Exercícios'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Botão para submeter o treino
            ElevatedButton(
              onPressed: () async {
                try {
                  // Chama o método submitWorkout para enviar o treino
                  await context.read<WorkoutCreateViewModel>().submitWorkout();

                  // Exibe uma Snackbar de confirmação
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Treino confirmado com sucesso!')),
                  );

                  // Navega para a tela inicial e remove as telas anteriores
                  Navigator.pushNamedAndRemoveUntil(context, RouteGeneratorHelper.kInitial, (Route) => false);
                } catch (error) {
                  // Em caso de erro, exibe uma mensagem
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao confirmar treino: $error')),
                  );
                }
              },
              child: const Text('Confirmar Treino'),
            ),
          ],
        ),
      ),
    );
  }
}

