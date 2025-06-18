import 'package:flutter_test/flutter_test.dart';
import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';
import 'package:muscle_up_mobile/data/repositories/workout/fake_workout_repository.dart';

void main() {
  group('WorkoutCreateViewModel', () {
    late WorkoutCreateViewModel viewModel;
    late FakeWorkoutRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeWorkoutRepository();
      viewModel = WorkoutCreateViewModel(fakeRepo);
    });

    test('deve carregar exercícios disponíveis', () async {
      await viewModel.loadExercises();

      expect(viewModel.availableExercises.length, 4);
      expect(viewModel.availableExercises.first.name, 'Supino Reto');
    });

    test('deve criar treino completo com sucesso', () async {
      await viewModel.loadExercises();

      viewModel.setWorkoutInfo('Novo Treino', workoutInfoTypeEnum.ab);
      viewModel.addMuscleDay(WorkoutTypeEnum.A, MuscleGroupEnum.peito);

      final exercise = fakeRepo.getAllExercises().then((list) => list.first);
      final selected = await exercise;

      viewModel.toggleExercise(
        WorkoutTypeEnum.A,
        MuscleGroupEnum.peito,
        selected,
      );
      await viewModel.submitWorkout();

      expect(viewModel.state, isA<RequestCompletedState>());

      final allWorkouts = await fakeRepo.getAllWorkouts();
      expect(allWorkouts.any((w) => w.name == 'Novo Treino'), true);
    });

    test('deve retornar erro ao tentar criar treino incompleto', () async {
      await viewModel.submitWorkout();

      expect(viewModel.state, isA<RequestErrorState>());
      final error = viewModel.state as RequestErrorState;
      expect(error.error.toString(), contains('Preencha todas'));
    });
  });
}
