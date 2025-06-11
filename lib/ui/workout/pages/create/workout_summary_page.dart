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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Resumo do Treino',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nome do treino
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nome do Treino: ${context.read<WorkoutCreateViewModel>().workoutName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo do treino
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tipo de Treino: ${context.read<WorkoutCreateViewModel>().workoutType?.name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de grupos musculares com os exercícios
            Expanded(
              child: ListView.builder(
                itemCount:
                    context.read<WorkoutCreateViewModel>().muscleDays.length,
                itemBuilder: (context, index) {
                  final muscleDay = context
                      .read<WorkoutCreateViewModel>()
                      .muscleDays[index];
                  final selectedExercises = context
                      .read<WorkoutCreateViewModel>()
                      .getSelectedExercisesForDayAndMuscleGroup(
                          muscleDay.type, muscleDay.muscleGroup);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dia ${muscleDay.type.name} - ${muscleDay.muscleGroup.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...selectedExercises.map((exercise) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              exercise.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            subtitle: Text(
                              'Séries: ${exercise.sets}, Reps: ${exercise.reps}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () {
                                context
                                    .read<WorkoutCreateViewModel>()
                                    .toggleExercise(muscleDay.type,
                                        muscleDay.muscleGroup, exercise);
                              },
                            ),
                          );
                        }).toList(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteGeneratorHelper.kWorkoutExercises,
                              arguments: {
                                'viewModel':
                                    context.read<WorkoutCreateViewModel>(),
                                'dayType': muscleDay.type,
                                'muscleGroup': muscleDay.muscleGroup,
                              },
                            );
                          },
                          child: const Text(
                            'Adicionar Exercícios',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Botão de confirmar treino
            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await context
                          .read<WorkoutCreateViewModel>()
                          .submitWorkout();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Treino confirmado com sucesso!'),
                        ),
                      );

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteGeneratorHelper.kWorkouts,
                        (Route) => false,
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao confirmar treino: $error'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2F57),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Confirmar Treino',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
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
