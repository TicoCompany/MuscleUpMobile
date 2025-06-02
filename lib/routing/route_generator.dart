import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/configs/injection_conteiner.dart';
import 'package:muscle_up_mobile/core/service/app_service.dart';
import 'package:muscle_up_mobile/ui/login/pages/login_page.dart';
import 'package:muscle_up_mobile/ui/workout/pages/workout_screen.dart';
import 'package:muscle_up_mobile/ui/workout/pages/workout_details_screen.dart'; 
import 'package:muscle_up_mobile/ui/workout/pages/muscle_day_screen.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';   


final class RouteGeneratorHelper {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;

    return switch (settings.name) {
      kInitial => createRoutePage(const WorkoutPage()),
      kLogin => createRoutePage(const LoginPage()),
      kHome => createRoutePage(const LoginPage()),

      kWorkoutDetails when args is WorkoutEntity =>
        createRoutePage(WorkoutDetailsPage(workout: args)),

      kMuscleDayDetails when args is MuscleDayEntity =>
        createRoutePage(MuscleDayPage(muscleDay: args)),

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

  static const String kInitial = '/';
  static const String kLogin = '/login';
  static const String kHome = '/home';

  // NOVAS ROTAS
  static const String kWorkoutDetails = '/workout/details';
  static const String kMuscleDayDetails = '/workout/muscleday';

  static void onRouteInitialization(String route) {
    if (route.isNotEmpty) {
      getIt<IAppService>().navigateNamedReplacementTo(route);
    }
  }
}

