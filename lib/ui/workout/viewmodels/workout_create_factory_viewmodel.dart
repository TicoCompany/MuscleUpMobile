import 'package:muscle_up_mobile/configs/factory_viewmodel.dart';
import 'package:muscle_up_mobile/data/repositories/workout/fake_workout_repository.dart';
import 'package:muscle_up_mobile/data/repositories/workout/workout_repository.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';

final class WorkoutCreateFactoryViewModel implements IFactoryViewModel<WorkoutCreateViewModel> {
  @override
  WorkoutCreateViewModel create(BuildContext context) {
    // Usamos um repositório fake para evitar falhas de rede durante o fluxo
    // de criação de treino.
    final IWorkoutRepository workoutRepository = FakeWorkoutRepository();

    return WorkoutCreateViewModel(workoutRepository);
  }

  @override
  void dispose(BuildContext context, WorkoutCreateViewModel viewModel) {
    viewModel.close();
  }
}
