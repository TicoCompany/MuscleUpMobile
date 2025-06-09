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
  final List<List<MuscleGroupEnum>> _muscleDays = [];

  void _addMuscleDay() {
    setState(() {
      _muscleDays.add([]);
    });
  }

  void _toggleMuscleGroup(int dayIndex, MuscleGroupEnum group) {
    setState(() {
      final currentList = _muscleDays[dayIndex];
      if (currentList.contains(group)) {
        currentList.remove(group);
      } else {
        currentList.add(group);
      }
    });
  }

  void _submit() {
    final viewModel = context.read<WorkoutCreateViewModel>();

    for (int i = 0; i < _muscleDays.length; i++) {
      final type = WorkoutTypeEnum.values[i];
      for (final group in _muscleDays[i]) {
        viewModel.addMuscleDay(type, group);
      }
    }

    Navigator.pushNamed(
  context,
  RouteGeneratorHelper.kWorkoutExercises,
  arguments: viewModel,
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grupos Musculares')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _muscleDays.length,
                itemBuilder: (context, index) {
                  final type = WorkoutTypeEnum.values[index];
                  final selected = _muscleDays[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dia ${type.name}',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: MuscleGroupEnum.values.map((group) {
                              final isSelected = selected.contains(group);
                              return FilterChip(
                                label: Text(group.name),
                                selected: isSelected,
                                onSelected: (_) =>
                                    _toggleMuscleGroup(index, group),
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
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addMuscleDay,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Dia'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _muscleDays.isEmpty ? null : _submit,
                  child: const Text('Continuar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
