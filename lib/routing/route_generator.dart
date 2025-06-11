import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/configs/injection_conteiner.dart';
import 'package:muscle_up_mobile/core/service/app_service.dart';

import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';

import 'package:muscle_up_mobile/ui/login/pages/login_page.dart';
import 'package:muscle_up_mobile/ui/workout/pages/workout_screen.dart';
import 'package:muscle_up_mobile/ui/workout/pages/workout_details_screen.dart';
import 'package:muscle_up_mobile/ui/workout/pages/muscle_day_screen.dart';
import 'package:muscle_up_mobile/ui/workout/pages/exercise_details_screen.dart';
import 'package:muscle_up_mobile/ui/workout/pages/home_page.dart';

// Páginas do fluxo de criação de treino
import 'package:muscle_up_mobile/ui/workout/pages/create/workout_info_page.dart';
import 'package:muscle_up_mobile/ui/workout/pages/create/muscle_group_selection_page.dart';
import 'package:muscle_up_mobile/ui/workout/pages/create/exercise_selection_page.dart';
import 'package:muscle_up_mobile/ui/workout/pages/create/workout_summary_page.dart'; // Importa a tela de resumo

import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';

final class RouteGeneratorHelper {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;

    return switch (settings.name) {
      kWorkouts => createRoutePage(const WorkoutPage()),
      kLogin => createRoutePage(const LoginPage()),
      kHome => createRoutePage(const HomePage()),

      kWorkoutDetails when args is WorkoutEntity => createRoutePage(
        WorkoutDetailsPage(workout: args),
      ),

      kMuscleDayDetails when args is List<MuscleDayEntity> => createRoutePage(
        MuscleDayPage(muscleDays: args),
      ),

      kExerciseDetails when args is ExerciseEntity => createRoutePage(
        ExerciseDetailsPage(exercise: args),
      ),

      // Criação de treino
      kWorkoutInfo => createRoutePage(const WorkoutInfoPage()),

      kWorkoutMuscles when args is WorkoutCreateViewModel => createRoutePage(
        MuscleGroupSelectionPage(viewModel: args),
      ),

      kWorkoutExercises when args is Map<String, dynamic> => createRoutePage(
        ExerciseSelectionPage(
          viewModel: args['viewModel'], // Passando o viewModel
          dayType: args['dayType'], // Passando o dayType
          muscleGroup: args['muscleGroup'], // Passando o muscleGroup
        ),
      ),

      // Resumo do treino (nova tela)
      kWorkoutSummary when args is WorkoutCreateViewModel => createRoutePage(
        WorkoutSummaryPage(viewModel: args),
      ),

      _ => createRouteError(),
    };
  }

  static PageRoute createRoutePage(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> createRouteError() {
    return MaterialPageRoute(
      builder: (context) {
        return const Scaffold(body: Center(child: Text('Error Route')));
      },
    );
  }

  static const String kWorkouts = '/';
  static const String kLogin = '/login';
  static const String kHome = '/home';

  // Detalhes
  static const String kWorkoutDetails = '/workout/details';
  static const String kMuscleDayDetails = '/workout/muscleday';
  static const String kExerciseDetails = '/workout/exercise';

  // Criação de treino
  static const String kWorkoutInfo = '/workout/info';
  static const String kWorkoutMuscles = '/workout/muscles';
  static const String kWorkoutExercises = '/workout/exercises';

  // Resumo do treino (nova rota)
  static const String kWorkoutSummary = '/workout/summary';

  static void onRouteInitialization(String route) {
    if (route.isNotEmpty) {
      getIt<IAppService>().navigateNamedReplacementTo(route);
    }
  }
}
