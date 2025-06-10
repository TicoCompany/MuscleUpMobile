import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/core/library/extensions.dart';
import 'package:muscle_up_mobile/domain/entities/workout/exercice_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source.dart';
import 'package:muscle_up_mobile/domain/entities/core/http_response_entity.dart';
import 'package:muscle_up_mobile/domain/error/workout/workout_exception.dart';

abstract interface class IWorkoutRepository {
  Future<List<WorkoutEntity>> getAllWorkouts();
  Future<void> saveWorkoutLocallyAsync(WorkoutEntity workout);
  Future<void> createWorkout(WorkoutEntity workout);
  Future<List<ExerciseEntity>> getAllExercises();
}

final class WorkoutRepository implements IWorkoutRepository {
  final IRemoteDataSource _remoteDataSource;
  final IRelationalDataSource _relationalDataSource;

  const WorkoutRepository(this._remoteDataSource, this._relationalDataSource);

  @override
  Future<List<WorkoutEntity>> getAllWorkouts() async {
    final String url = _remoteDataSource.environment?.urlWorkout ?? '';

    try {
      final HttpResponseEntity? response = await _remoteDataSource.get(url);

      if (response == null || !response.toBool() || response.data == null) {
        throw WorkoutNotFoundException();
      }

      final List<dynamic> dataList = response.data;
      final workouts = dataList.map((e) => WorkoutEntity.fromMap(e)).toList();

      for (final workout in workouts) {
        await saveWorkoutLocallyAsync(workout);
      }

      return workouts;
    } catch (e) {
      final localWorkouts = await _getAllWorkoutsFromDbAsync();
      if (localWorkouts.isEmpty) throw WorkoutNotFoundException();
      return localWorkouts;
    }
  }

  @override
  Future<void> saveWorkoutLocallyAsync(WorkoutEntity workout) async {
    await _relationalDataSource.delete(
      'workout',
      where: 'id = ?',
      whereArgs: [workout.id],
    );

    await _relationalDataSource.insert('workout', {
      'id': workout.id,
      'name': workout.name,
      'type': workout.type.name,
    });

    for (final muscleDay in workout.muscleDays) {
      await _relationalDataSource.insert('muscle_day', {
        'id': muscleDay.id,
        'workoutId': workout.id,
        'type': muscleDay.type,
        'muscleGroups': muscleDay.muscleGroup,
      });

      for (final exercise in muscleDay.exercises) {
        await _relationalDataSource.insert('exercise', {
          'id': exercise.id,
          'muscleDayId': muscleDay.id,
          'name': exercise.name,
          'sets': exercise.sets,
          'reps': exercise.reps,
          'weight': exercise.weight,
          'notes': exercise.notes,
        });
      }
    }
  }

  Future<List<WorkoutEntity>> _getAllWorkoutsFromDbAsync() async {
    final workoutMaps = await _relationalDataSource.rawQuery('SELECT * FROM workout') ?? [];
    final muscleDayMaps = await _relationalDataSource.rawQuery('SELECT * FROM muscle_day') ?? [];
    final exerciseMaps = await _relationalDataSource.rawQuery('SELECT * FROM exercise') ?? [];

    return workoutMaps.map((workout) {
      final muscleDaysForWorkout = muscleDayMaps.where((m) => m['workoutId'] == workout['id']).map((muscleDay) {
        final exercisesForMuscleDay = exerciseMaps.where((e) => e['muscleDayId'] == muscleDay['id']).map((exercise) {
          return ExerciseEntity(
            id: exercise['id'],
            name: exercise['name'],
            sets: exercise['sets'],
            reps: exercise['reps'],
            weight: exercise['weight'],
            notes: exercise['notes'],
          );
        }).toList();

        return MuscleDayEntity(
          id: muscleDay['id'],
          type: muscleDay['type'],
          muscleGroup: muscleDay['muscleGroups'],
          exercises: exercisesForMuscleDay,
        );
      }).toList();

      return WorkoutEntity(
        id: workout['id'],
        name: workout['name'],
        type: workoutInfoTypeEnum.values.firstWhere(
          (e) => e.name == workout['type'],
          orElse: () => workoutInfoTypeEnum.A,
        ),
        muscleDays: muscleDaysForWorkout,
      );
    }).toList();
  }

  @override
Future<void> createWorkout(WorkoutEntity workout) async {
  final String url = _remoteDataSource.environment?.urlWorkout ?? '';
  final String body = jsonEncode(workout.toMap());

  try {
    final HttpResponseEntity? response = await _remoteDataSource.post(url, body);

    if (response == null || !response.toBool()) {
      throw Exception('Erro ao criar treino');
    }

  } catch (e) {
    throw Exception('Falha ao enviar o treino: $e');
  }
}


  @override
  Future<List<ExerciseEntity>> getAllExercises() async {
    final String url = _remoteDataSource.environment?.urlExercise ?? '';

    try {
      final HttpResponseEntity? response = await _remoteDataSource.get(url);

      if (response == null || !response.toBool() || response.data == null) {
        throw Exception('Falha ao buscar exercícios.');
      }

      final List<dynamic> dataList = response.data;
      return dataList.map((e) => ExerciseEntity.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }
}
