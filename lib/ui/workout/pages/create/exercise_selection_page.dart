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

class _WorkoutExercisesScreenBodyState extends State<_WorkoutExercisesScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  List<ExerciseEntity> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    context.read<WorkoutCreateViewModel>().loadExercises();
    _filteredExercises = context.read<WorkoutCreateViewModel>().availableExercises;
  }

  // Filtrando os exercícios
  void _filterExercises() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = context.read<WorkoutCreateViewModel>().availableExercises
          .where((exercise) => exercise.name.toLowerCase().contains(query))
          .toList();
    });
  }

  // Alternando a seleção de exercício
  void _toggleExercise(ExerciseEntity exercise) {
    final viewModel = context.read<WorkoutCreateViewModel>();
    viewModel.toggleExercise(widget.dayType, widget.muscleGroup, exercise);
  }

  // Finalizando o treino
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
      appBar: AppBar(title: const Text('Selecione os Exercícios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de busca de exercícios
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Pesquisar Exercício'),
              onChanged: (_) => _filterExercises(),
            ),
            const SizedBox(height: 8),
            // Lista de exercícios
            Expanded(
              child: ListView.builder(
                itemCount: _filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _filteredExercises[index];
                  final isSelected = viewModel.isExerciseSelected(widget.dayType, widget.muscleGroup, exercise);
                  return ListTile(
                    title: Text(exercise.name),
                    trailing: IconButton(
                      icon: Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline),
                      onPressed: () {
                        _toggleExercise(exercise);
                      },
                    ),
                    onTap: () {
                      // Exibe o diálogo de configuração do exercício
                      showDialog(
                        context: context,
                        builder: (_) => _buildExerciseDialog(exercise),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Botão de finalização
            ElevatedButton(
              onPressed: viewModel.getSelectedExercisesForDayAndMuscleGroup(widget.dayType, widget.muscleGroup).isEmpty ? null : _submit,
              child: const Text('Finalizar Treino'),
            ),
          ],
        ),
      ),
    );
  }

  // Função para configurar o exercício
  Widget _buildExerciseDialog(ExerciseEntity exercise) {
    final TextEditingController setsController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    return AlertDialog(
      title: Text('Configurar Exercício: ${exercise.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: setsController, decoration: const InputDecoration(labelText: 'Séries'), keyboardType: TextInputType.number),
          TextField(controller: repsController, decoration: const InputDecoration(labelText: 'Repetições'), keyboardType: TextInputType.number),
          TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Notas')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Atualiza o exercício com as informações fornecidas
            exercise.sets = int.parse(setsController.text);
            exercise.reps = int.parse(repsController.text);
            exercise.notes = notesController.text;

            setState(() {
              _toggleExercise(exercise);
            });
          },
          child: const Text('Adicionar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
