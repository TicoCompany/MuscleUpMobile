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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Treino ${UtilEnum.getWorkoutInfoTypeName(workout.type)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          itemCount: types.length,
          itemBuilder: (context, index) {
            final type = types[index];
            final muscleDaysOfType =
                muscleDays.where((e) => e.type == type).toList();

            final title = 'Treino ${UtilEnum.getWorkoutTypeName(type)}';

            // Obter os nomes dos grupos musculares únicos
            final muscleGroups = muscleDaysOfType
                .map((e) => e.muscleGroup.name)
                .toSet()
                .join(', ');

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteGeneratorHelper.kMuscleDayDetails,
                    arguments: muscleDaysOfType,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Grupos: $muscleGroups',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
