import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

class MuscleGroupSelectionPage extends StatelessWidget {
  final WorkoutCreateViewModel viewModel;

  const MuscleGroupSelectionPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutCreateViewModel>.value(
      value: viewModel,
      child: const _MuscleGroupSelectionScreenBody(),
    );
  }
}

class _MuscleGroupSelectionScreenBody extends StatefulWidget {
  const _MuscleGroupSelectionScreenBody();

  @override
  State<_MuscleGroupSelectionScreenBody> createState() =>
      _MuscleGroupSelectionScreenBodyState();
}

class _MuscleGroupSelectionScreenBodyState
    extends State<_MuscleGroupSelectionScreenBody> {
  final Map<WorkoutTypeEnum, List<MuscleGroupEnum>> _muscleDays = {};

  @override
  void initState() {
    super.initState();
    // Inicializando as sessões com base nos valores de WorkoutInfoTypeEnum
    _initializeMuscleDays();
  }

  // Função para inicializar as seções com base no tipo de treino
  void _initializeMuscleDays() {
    final workoutType = context.read<WorkoutCreateViewModel>().workoutType!;

    // Filtrando e criando sessões com base no tipo de treino
    for (var type in WorkoutTypeEnum.values) {
      if (workoutType.name.toLowerCase().contains(type.name.toLowerCase())) {
        _muscleDays[type] = []; // Inicializa a lista de grupos musculares vazia para cada dia
      }
    }

    // Preservar os grupos musculares selecionados se houver alguma seleção salva
    for (var type in _muscleDays.keys) {
      final selectedGroups = context.read<WorkoutCreateViewModel>().muscleDays
          .where((muscleDay) => muscleDay.type == type)
          .map((muscleDay) => muscleDay.muscleGroup)
          .toList();
      _muscleDays[type] = selectedGroups;
    }
  }

  // Função para alternar a seleção de grupo muscular
  void _toggleMuscleGroup(WorkoutTypeEnum type, MuscleGroupEnum group) {
  setState(() {
    if (_muscleDays[type]?.contains(group) ?? false) {
      _muscleDays[type]?.remove(group); // Remove o grupo muscular da lista
      // Também removemos da viewModel, garantindo que o grupo muscular desmarcado não seja passado
      context.read<WorkoutCreateViewModel>().removeMuscleGroup(type, group);
    } else {
      _muscleDays[type]?.add(group); // Adiciona o grupo muscular à lista
      // Adiciona o grupo muscular à viewModel, garantindo que o selecionado seja mantido
      context.read<WorkoutCreateViewModel>().addMuscleDay(type, group);
    }
  });
}


  void _submit() {
    final viewModel = context.read<WorkoutCreateViewModel>();

    // Para cada tipo de treino (A, B, C...), adicionar os grupos musculares selecionados
    _muscleDays.forEach((type, selectedGroups) {
      for (final group in selectedGroups) {
        viewModel.addMuscleDay(type, group); // Adiciona o dia com o grupo muscular
      }
    });

    // Navega para a tela de exercícios
    Navigator.pushNamed(
      context,
      RouteGeneratorHelper.kWorkoutSummary, // Página de exercícios
      arguments: viewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleção de Grupos Musculares')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _muscleDays.length,
                itemBuilder: (context, index) {
                  final workoutType = _muscleDays.keys.elementAt(index);
                  final selectedGroups = _muscleDays[workoutType]!;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título do dia baseado no tipo de treino (A, B, C...)
                          Text(
                            'Dia ${workoutType.name}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: MuscleGroupEnum.values.map((group) {
                              final isSelected = selectedGroups.contains(group);
                              return FilterChip(
                                label: Text(group.name),
                                selected: isSelected,
                                onSelected: (_) =>
                                    _toggleMuscleGroup(workoutType, group), // Alterna a seleção
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
              onPressed: _submit,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
