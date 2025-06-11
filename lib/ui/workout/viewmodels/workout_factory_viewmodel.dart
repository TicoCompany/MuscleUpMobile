import 'package:flutter/widgets.dart';
import 'package:muscle_up_mobile/configs/factory_viewmodel.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source_factory.dart';
import 'package:muscle_up_mobile/data/repositories/workout/workout_repository.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_viewmodel.dart';
import 'package:muscle_up_mobile/data/repositories/workout/fake_workout_repository.dart';

final class WorkoutFactoryViewModel implements IFactoryViewModel<WorkoutViewModel> {
  @override
  WorkoutViewModel create(BuildContext context) {
    final IRemoteDataSource remoteDataSource =
        RemoteFactoryDataSource().create(); 
    final IRelationalDataSource relationalDataSource =
        RelationalFactoryDataSource().create();

  /*final IWorkoutRepository workoutRepository =
        WorkoutRepository(remoteDataSource, relationalDataSource);

    return WorkoutViewModel(workoutRepository);
    */

    final IWorkoutRepository workoutRepository = getIt<IWorkoutRepository>();

    return WorkoutViewModel(workoutRepository);
  }

  @override
  void dispose(BuildContext context, WorkoutViewModel viewModel) {
    viewModel.close();
  }
}