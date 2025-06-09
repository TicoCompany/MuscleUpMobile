import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';
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
  WorkoutTypeEnum? _workoutType;
  final List<MuscleDayEntity> _muscleDays = [];
  final List<ExerciseEntity> _availableExercises = []; // Exercícios disponíveis

  // ▶ Define nome e tipo do treino
  void setWorkoutInfo(String name, WorkoutTypeEnum type) {
    _workoutName = name;
    _workoutType = type;
  }

  // ▶ Adiciona um dia de treino com grupo muscular (sem exercícios ainda)
  void addMuscleDay(WorkoutTypeEnum dayType, MuscleGroupEnum group) {
    _muscleDays.add(
      MuscleDayEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        type: dayType,
        muscleGroup: group,
        exercises: [], // Inicialmente sem exercícios
      ),
    );
  }

  // ▶ Carrega os exercícios disponíveis
 Future<void> loadExercises() async {
  try {
    _emit(RequestProcessingState()); // Emite estado de "carregando"

    final exercises = await _repository.getAllExercises();
    _availableExercises.clear(); // Limpa a lista antes de adicionar novos dados
    _availableExercises.addAll(exercises); // Adiciona os exercícios carregados

    _emit(const RequestCompletedState()); // Emite estado de "concluído"
  } catch (e) {
    _emit(RequestErrorState(error: 'Falha ao carregar os exercícios.'));
  }
}



  // ▶ Adiciona exercícios a um MuscleDay já criado
  void addExercisesToMuscleDay(int muscleDayId, List<ExerciseEntity> exercises) {
    final index = _muscleDays.indexWhere((e) => e.id == muscleDayId);
    if (index != -1) {
      final day = _muscleDays[index];
      _muscleDays[index] = MuscleDayEntity(
        id: day.id,
        type: day.type,
        muscleGroup: day.muscleGroup,
        exercises: exercises,
      );
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
      _emit(const RequestCompletedState());
    } catch (error) {
      _emit(RequestErrorState(error: error));
    }
  }

  // ▶ Reset total para criar outro treino
  void reset() {
    _workoutName = null;
    _workoutType = null;
    _muscleDays.clear();
    resetState();
  }

  // ▶ Reset apenas do estado de retorno
  void resetState() {
    _emit(const RequestInitiationState());
  }

  void _emit(IRequestState<void> state) {
    if (isClosed) return;
    emit(state);
  }

  // ▶ Getters para uso em tela de revisão/edição
  String? get workoutName => _workoutName;
  WorkoutTypeEnum? get workoutType => _workoutType;
  List<MuscleDayEntity> get muscleDays => List.unmodifiable(_muscleDays);
  List<ExerciseEntity> get availableExercises => List.unmodifiable(_availableExercises); // Exercícios disponíveis
}
