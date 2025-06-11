import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:muscle_up_mobile/configs/environment_helper.dart';
import 'package:muscle_up_mobile/core/service/app_service.dart';
import 'package:muscle_up_mobile/core/service/migrate_service.dart';
import 'package:muscle_up_mobile/core/service/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muscle_up_mobile/data/repositories/workout/workout_repository.dart';
import 'package:muscle_up_mobile/data/repositories/workout/fake_workout_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  /// #region EnvironmentHelper
  final IEnvironmentHelper environmentHelper = EnvironmentHelper();
  getIt.registerSingleton<IEnvironmentHelper>(environmentHelper);

  /// #region AppService
  getIt.registerSingleton<IAppService>(AppService(GlobalKey<NavigatorState>()));

  /// #region StorageService
  getIt.registerSingleton<IStorageService>(
    StorageService(MigrateService(), await SharedPreferences.getInstance()),
  );

  /// #region WorkoutRepository
  final IWorkoutRepository workoutRepository = FakeWorkoutRepository();
  getIt.registerSingleton<IWorkoutRepository>(workoutRepository);
}

