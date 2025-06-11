import 'dart:io';

import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/muscle_group_enum.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/data/repositories/workout/workout_repository.dart';
import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
import 'package:flutter/material.dart';

class FakeWorkoutRepository implements IWorkoutRepository {
  final List<WorkoutEntity> _fakeWorkouts = [
    WorkoutEntity(
      id: 1,
      name: 'Treino Hipertrofia',
      type: workoutInfoTypeEnum.ab,
      muscleDays: [
        MuscleDayEntity(
          id: 101,
          type: WorkoutTypeEnum.A,
          muscleGroup: MuscleGroupEnum.peito,
          exercises: [
            ExerciseEntity(
              id: 1001,
              name: 'Supino Reto',
              sets: 4,
              reps: 10,
              weight: 60,
              notes: 'Aquecimento leve na primeira série',
            ),
            ExerciseEntity(
              id: 1002,
              name: 'Supino Inclinado',
              sets: 3,
              reps: 12,
              weight: 25,
              notes: '',
            ),
          ],
        ),
        MuscleDayEntity(
          id: 102,
          type: WorkoutTypeEnum.A,
          muscleGroup: MuscleGroupEnum.triceps,
          exercises: [
            ExerciseEntity(
              id: 1003,
              name: 'Mergulho em Paralela',
              sets: 3,
              reps: 8,
              weight: 0,
              notes: 'Peso corporal',
            ),
          ],
        ),
        MuscleDayEntity(
          id: 5,
          type: WorkoutTypeEnum.B,
          muscleGroup: MuscleGroupEnum.biceps,
          exercises: [
            ExerciseEntity(
              id: 1004,
              name: 'Rosca Direta',
              sets: 3,
              reps: 10,
              weight: 20,
              notes: 'Use barra reta',
            ),
          ],
        ),
      ],
    ),
  ];

  final List<ExerciseEntity> _fakeExercises = [
  ExerciseEntity(
    id: 1,
    name: 'Supino Reto',
    sets: 4,
    reps: 10,
    weight: 60,
    notes: 'Aquecimento leve na primeira série',
  ),
  ExerciseEntity(
    id: 2,
    name: 'Tríceps Testa',
    sets: 3,
    reps: 12,
    weight: 25,
    notes: 'Executar com barra EZ',
  ),
  ExerciseEntity(
    id: 3,
    name: 'Puxada na Barra Fixa',
    sets: 3,
    reps: 8,
    weight: 0,
    notes: 'Peso corporal',
  ),
  ExerciseEntity(
    id: 4,
    name: 'Rosca Alternada',
    sets: 3,
    reps: 10,
    weight: 14,
    notes: 'Com halteres',
  ),
];


  @override
  Future<List<WorkoutEntity>> getAllWorkouts() async {
    await Future.delayed(Duration(milliseconds: 300)); // simula carregamento
    return _fakeWorkouts;
  }

  @override
  Future<void> saveWorkoutLocallyAsync(WorkoutEntity workout) async {
    _fakeWorkouts.removeWhere((w) => w.id == workout.id);
    _fakeWorkouts.add(workout);
  }

 @override
Future<void> createWorkout(WorkoutEntity workout) async {
  await Future.delayed(Duration(milliseconds: 300)); // simula carregamento

  // Adicionar o treino à lista simulada
  _fakeWorkouts.add(workout);
}


  @override
  Future<List<ExerciseEntity>> getAllExercises() async {
    await Future.delayed(Duration(milliseconds: 300)); // simula carregamento
    return _fakeExercises;
  }
}
