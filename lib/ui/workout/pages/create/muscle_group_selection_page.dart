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
    _initializeMuscleDays();
  }

  void _initializeMuscleDays() {
    final workoutType = context.read<WorkoutCreateViewModel>().workoutType!;

    for (var type in WorkoutTypeEnum.values) {
      if (workoutType.name.toLowerCase().contains(type.name.toLowerCase())) {
        _muscleDays[type] = [];
      }
    }

    for (var type in _muscleDays.keys) {
      final selectedGroups = context.read<WorkoutCreateViewModel>().muscleDays
          .where((muscleDay) => muscleDay.type == type)
          .map((muscleDay) => muscleDay.muscleGroup)
          .toList();
      _muscleDays[type] = selectedGroups;
    }
  }

  void _toggleMuscleGroup(WorkoutTypeEnum type, MuscleGroupEnum group) {
    setState(() {
      if (_muscleDays[type]?.contains(group) ?? false) {
        _muscleDays[type]?.remove(group);
        context.read<WorkoutCreateViewModel>().removeMuscleGroup(type, group);
      } else {
        _muscleDays[type]?.add(group);
        context.read<WorkoutCreateViewModel>().addMuscleDay(type, group);
      }
    });
  }

  void _submit() {
    final viewModel = context.read<WorkoutCreateViewModel>();
    _muscleDays.forEach((type, selectedGroups) {
      for (final group in selectedGroups) {
        viewModel.addMuscleDay(type, group);
      }
    });

    Navigator.pushNamed(
      context,
      RouteGeneratorHelper.kWorkoutSummary,
      arguments: viewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Seleção de Grupos Musculares',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _muscleDays.length,
                itemBuilder: (context, index) {
                  final workoutType = _muscleDays.keys.elementAt(index);
                  final selectedGroups = _muscleDays[workoutType]!;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dia ${workoutType.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: MuscleGroupEnum.values.map((group) {
                            final isSelected = selectedGroups.contains(group);
                            return FilterChip(
                              label: Text(group.name),
                              selected: isSelected,
                              selectedColor: const Color(0xFF2C2F57),
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (_) =>
                                  _toggleMuscleGroup(workoutType, group),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2F57),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Continuar',
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
