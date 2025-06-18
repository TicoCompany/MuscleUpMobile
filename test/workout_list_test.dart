import 'package:flutter_test/flutter_test.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_viewmodel.dart';
import 'package:muscle_up_mobile/data/repositories/workout/fake_workout_repository.dart';

void main() {
  group('WorkoutViewModel', () {
    late WorkoutViewModel viewModel;

    setUp(() {
      viewModel = WorkoutViewModel(FakeWorkoutRepository());
    });

    test('deve carregar a lista de treinos com sucesso', () async {
      await viewModel.loadWorkouts();

      expect(
        viewModel.state,
        isA<RequestCompletedState<List<WorkoutEntity>>>(),
      );

      final result =
          viewModel.state as RequestCompletedState<List<WorkoutEntity>>;
      final workouts = result.value!;
      expect(workouts.length, 1);
      expect(workouts.first.name, 'Treino Hipertrofia');
    });
  });
}
