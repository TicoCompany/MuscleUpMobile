import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/utils/util_enum.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';


class WorkoutDetailsPage extends StatelessWidget {
  final WorkoutEntity workout;
  const WorkoutDetailsPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
  final muscleDays = workout.muscleDays;
  final types = muscleDays.map((e) => e.type).toSet().toList();

  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6A7091), Colors.white],
          stops: [0.0, 0.35],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              workout.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Treino ${UtilEnum.getWorkoutTypeName(workout.type)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                itemCount: types.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final type = types[index];
                  return GestureDetector(
                    onTap: () {
                      final muscleDaysOfType =
                          muscleDays.where((e) => e.type == type).toList();

                      Navigator.pushNamed(
                        context,
                        RouteGeneratorHelper.kMuscleDayDetails,
                        arguments: muscleDaysOfType,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    Text(
                                      'Treino ${UtilEnum.getWorkoutTypeName(type)}',
                                       style: const TextStyle(
                                       fontSize: 14,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black87,
                                       ),
                                      ),
                                       const SizedBox(height: 4),
                                        Text(
                                          'Descrição do treino para ${UtilEnum.getWorkoutTypeName(type).toLowerCase()}.',
                                          style: const TextStyle(
                                             fontSize: 13,
                                            color: Colors.black54,
                          ),
                        ),
                      ],
                     ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
 
}