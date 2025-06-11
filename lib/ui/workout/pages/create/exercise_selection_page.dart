import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';

class ExerciseSelectionPage extends StatelessWidget {
  final WorkoutCreateViewModel viewModel;
  final WorkoutTypeEnum dayType;
  final MuscleGroupEnum muscleGroup;

  const ExerciseSelectionPage({
    required this.viewModel,
    required this.dayType,
    required this.muscleGroup,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutCreateViewModel>.value(
      value: viewModel,
      child: _WorkoutExercisesScreenBody(
        dayType: dayType,
        muscleGroup: muscleGroup,
      ),
    );
  }
}

class _WorkoutExercisesScreenBody extends StatefulWidget {
  final WorkoutTypeEnum dayType;
  final MuscleGroupEnum muscleGroup;

  const _WorkoutExercisesScreenBody({
    required this.dayType,
    required this.muscleGroup,
  });

  @override
  _WorkoutExercisesScreenBodyState createState() =>
      _WorkoutExercisesScreenBodyState();
}

class _WorkoutExercisesScreenBodyState
    extends State<_WorkoutExercisesScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  List<ExerciseEntity> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    context.read<WorkoutCreateViewModel>().loadExercises();
    _filteredExercises =
        context.read<WorkoutCreateViewModel>().availableExercises;
  }

  void _filterExercises() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = context
          .read<WorkoutCreateViewModel>()
          .availableExercises
          .where((exercise) => exercise.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleExercise(ExerciseEntity exercise) {
    final viewModel = context.read<WorkoutCreateViewModel>();
    viewModel.toggleExercise(widget.dayType, widget.muscleGroup, exercise);
  }

  void _submit() {
    Navigator.pushNamed(
      context,
      RouteGeneratorHelper.kWorkoutSummary,
      arguments: context.read<WorkoutCreateViewModel>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutCreateViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Selecione os Exercícios',
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Exercício',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _filterExercises(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _filteredExercises[index];
                  final isSelected = viewModel.isExerciseSelected(
                      widget.dayType, widget.muscleGroup, exercise);

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
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          color: isSelected
                              ? const Color(0xFF2C2F57)
                              : Colors.grey[600],
                        ),
                        onPressed: () => _toggleExercise(exercise),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => _buildExerciseDialog(exercise),
                        );
                      },
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
                  onPressed: viewModel
                          .getSelectedExercisesForDayAndMuscleGroup(
                              widget.dayType, widget.muscleGroup)
                          .isEmpty
                      ? null
                      : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2F57),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Finalizar Treino',
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

  Widget _buildExerciseDialog(ExerciseEntity exercise) {
    final TextEditingController setsController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    return AlertDialog(
      title: Text('Configurar Exercício: ${exercise.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: setsController,
            decoration: const InputDecoration(labelText: 'Séries'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: repsController,
            decoration: const InputDecoration(labelText: 'Repetições'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(labelText: 'Notas'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            exercise.sets = int.tryParse(setsController.text) ?? 0;
            exercise.reps = int.tryParse(repsController.text) ?? 0;
            exercise.notes = notesController.text;
            setState(() {
              _toggleExercise(exercise);
            });
          },
          child: const Text('Adicionar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
