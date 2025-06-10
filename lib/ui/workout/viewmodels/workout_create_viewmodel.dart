import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/data/repositories/workout/workout_repository.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';

final class WorkoutCreateViewModel extends Cubit<IRequestState<void>> {
  final IWorkoutRepository _repository;

  WorkoutCreateViewModel(this._repository) : super(const RequestInitiationState());

  // 🔧 Dados em construção
  String? _workoutName;
  workoutInfoTypeEnum? _workoutType;
  final List<MuscleDayEntity> _muscleDays = [];
  final List<ExerciseEntity> _availableExercises = []; // Exercícios disponíveis
  final Map<WorkoutTypeEnum, Map<MuscleGroupEnum, List<ExerciseEntity>>> _selectedExercisesByDay = {}; // Exercícios por dia e grupo muscular

  // ▶ Define nome e tipo do treino
  void setWorkoutInfo(String name, workoutInfoTypeEnum type) {
    _workoutName = name;
    _workoutType = type;
  }

  // ▶ Adiciona um dia de treino com grupo muscular (sem exercícios ainda)
  void addMuscleDay(WorkoutTypeEnum dayType, MuscleGroupEnum group) {
    final existingDay = _muscleDays.firstWhere(
      (day) => day.type == dayType && day.muscleGroup == group,
      orElse: () => MuscleDayEntity(id: 0, type: dayType, muscleGroup: group, exercises: []),
    );

    if (existingDay.id == 0) {
      _muscleDays.add(
        MuscleDayEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          type: dayType,
          muscleGroup: group,
          exercises: [],
        ),
      );
    }
  }

  // ▶ Remove um grupo muscular específico
  void removeMuscleGroup(WorkoutTypeEnum dayType, MuscleGroupEnum group) {
    _muscleDays.removeWhere((day) => day.type == dayType && day.muscleGroup == group);
    _selectedExercisesByDay[dayType]?.remove(group); // Remove os exercícios associados ao grupo muscular
  }

  // ▶ Adiciona ou remove um exercício de um MuscleDay específico
  void toggleExercise(WorkoutTypeEnum dayType, MuscleGroupEnum muscleGroup, ExerciseEntity exercise) {
    // Verifica se o mapa de exercícios do dia existe
    if (!_selectedExercisesByDay.containsKey(dayType)) {
      _selectedExercisesByDay[dayType] = {};
    }

    // Verifica se o grupo muscular do dia existe
    if (!_selectedExercisesByDay[dayType]!.containsKey(muscleGroup)) {
      _selectedExercisesByDay[dayType]![muscleGroup] = [];
    }

    // Adiciona ou remove o exercício do grupo muscular
    if (_selectedExercisesByDay[dayType]![muscleGroup]!.contains(exercise)) {
      _selectedExercisesByDay[dayType]![muscleGroup]!.remove(exercise); // Remove o exercício
    } else {
      _selectedExercisesByDay[dayType]![muscleGroup]!.add(exercise); // Adiciona o exercício
    }

    emit(const RequestCompletedState());
  }

  // ▶ Carrega os exercícios disponíveis
  Future<void> loadExercises() async {
    try {
      _emit(RequestProcessingState());
      final exercises = await _repository.getAllExercises();
      _availableExercises.clear();
      _availableExercises.addAll(exercises);
      _emit(const RequestCompletedState());
    } catch (e) {
      _emit(RequestErrorState(error: 'Falha ao carregar os exercícios.'));
    }
  }

  // ▶ Submete o treino pro backend
  Future<void> submitWorkout() async {
  if (_workoutName == null || _workoutType == null || _muscleDays.isEmpty) {
    _emit(RequestErrorState(error: 'Preencha todas as etapas do treino'));
    return;
  }

  try {
    _emit(RequestProcessingState());
    final workout = WorkoutEntity(
      id: -1, // ID será atribuído pelo backend
      name: _workoutName!,
      type: _workoutType!,
      muscleDays: List.unmodifiable(_muscleDays),
    );
    await _repository.createWorkout(workout);
    
    // Atualiza a lista de treinos após a criação do novo treino
    _repository.getAllWorkouts(); // Recarregar a lista de treinos
    _emit(const RequestCompletedState());
  } catch (error) {
    _emit(RequestErrorState(error: error));
  }
}


  void _emit(IRequestState<void> state) {
    if (isClosed) return;
    emit(state);
  }

  // ▶ Getters para uso em tela de revisão/edição
  String? get workoutName => _workoutName;
  workoutInfoTypeEnum? get workoutType => _workoutType;
  List<MuscleDayEntity> get muscleDays => List.unmodifiable(_muscleDays);
  List<ExerciseEntity> get availableExercises => List.unmodifiable(_availableExercises);

  // ▶ Retorna os exercícios selecionados por dia e grupo muscular
  List<ExerciseEntity> getSelectedExercisesForDayAndMuscleGroup(WorkoutTypeEnum dayType, MuscleGroupEnum muscleGroup) {
    return _selectedExercisesByDay[dayType]?[muscleGroup] ?? [];
  }

  // ▶ Verifica se o exercício foi selecionado para o dia e grupo muscular
  bool isExerciseSelected(WorkoutTypeEnum dayType, MuscleGroupEnum muscleGroup, ExerciseEntity exercise) {
    return _selectedExercisesByDay[dayType]?[muscleGroup]?.contains(exercise) ?? false;
  }
}
