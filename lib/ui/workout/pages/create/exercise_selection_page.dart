import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

class ExerciseSelectionPage extends StatelessWidget {
  final WorkoutCreateViewModel viewModel;

  const ExerciseSelectionPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutCreateViewModel>.value(
      value: viewModel,
      child: const _WorkoutExercisesScreenBody(),
    );
  }
}

class _WorkoutExercisesScreenBody extends StatefulWidget {
  const _WorkoutExercisesScreenBody();

  @override
  State<_WorkoutExercisesScreenBody> createState() =>
      _WorkoutExercisesScreenBodyState();
}

class _WorkoutExercisesScreenBodyState
    extends State<_WorkoutExercisesScreenBody> {
  final Map<int, List<ExerciseEntity>> _selectedExercises = {}; // Mapeia os dias e os exercícios

  @override
  void initState() {
    super.initState();
    // Carregar os exercícios quando a tela for criada
    context.read<WorkoutCreateViewModel>().loadExercises();
  }

  void _toggleExercise(int muscleDayId, ExerciseEntity exercise) {
    setState(() {
      if (_selectedExercises[muscleDayId]?.contains(exercise) ?? false) {
        _selectedExercises[muscleDayId]?.remove(exercise);
      } else {
        _selectedExercises.putIfAbsent(muscleDayId, () => []).add(exercise);
      }
    });
  }

  void _submit() {
    final viewModel = context.read<WorkoutCreateViewModel>();

    // Adiciona os exercícios selecionados aos MuscleDayEntity correspondentes
    _selectedExercises.forEach((muscleDayId, exercises) {
      viewModel.addExercisesToMuscleDay(muscleDayId, exercises); // Atualiza os exercícios para cada MuscleDay
    });

    // Navega para a tela de resumo
    Navigator.pushNamed(
      context,
      RouteGeneratorHelper.kWorkoutSummary, // Página de resumo do treino
      arguments: viewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutCreateViewModel>();

    // Exibe um indicador de carregamento enquanto os exercícios não são carregados
    if (viewModel.availableExercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Selecione os Exercícios')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Selecione os Exercícios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Exibe a lista de grupos musculares e seus exercícios disponíveis
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.muscleDays.length,
                itemBuilder: (context, index) {
                  final muscleDay = viewModel.muscleDays[index];
                  final exercises = viewModel.availableExercises;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dia ${muscleDay.type.name} - ${muscleDay.muscleGroup.name}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: exercises.map((exercise) {
                              final isSelected =
                                  _selectedExercises[muscleDay.id]
                                          ?.contains(exercise) ??
                                      false;
                              return FilterChip(
                                label: Text(exercise.name),
                                selected: isSelected,
                                onSelected: (_) => _toggleExercise(
                                    muscleDay.id, exercise),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _selectedExercises.isEmpty ? null : _submit,
              child: const Text('Finalizar Treino'),
            ),
          ],
        ),
      ),
    );
  }
}
