import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/data/repositories/workout/workout_repository.dart';

final class WorkoutViewModel extends Cubit<IRequestState<List<WorkoutEntity>>> {
  final IWorkoutRepository _repository;

  WorkoutViewModel(this._repository)
      : super(const RequestInitiationState());

  Future<void> loadWorkouts() async {
    try {
      _emit(RequestProcessingState());

      final workouts = await _repository.getAllWorkouts();
      _emit(RequestCompletedState(value: workouts));
    } catch (error) {
      _emit(RequestErrorState(error: error));
    }
  }

  void _emit(IRequestState<List<WorkoutEntity>> state) {
    if (isClosed) return;
    emit(state);
  }

  
}
