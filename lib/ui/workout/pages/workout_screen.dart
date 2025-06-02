import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/configs/assets_helper.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/muscle_day_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_viewmodel.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_factory_viewmodel.dart';
import 'package:muscle_up_mobile/utils/util_enum.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutViewModel>(
      create: (_) => WorkoutFactoryViewModel().create(context)..loadWorkouts(),
      child: const _WorkoutScreenBody(),
    );
  }
}

class _WorkoutScreenBody extends StatelessWidget {
  const _WorkoutScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A7091), Colors.white],
            stops: [0.0, 0.40],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Image.asset(
                    AssetsHelper.kLogo,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text(
                      'Meus Treinos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(child: _WorkoutListWidget()),
                  ],
                ),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _WorkoutListWidget extends StatelessWidget {
  const _WorkoutListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutViewModel, IRequestState<List<WorkoutEntity>>>(
      builder: (context, state) {
        if (state is RequestProcessingState || state is RequestInitiationState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RequestErrorState) {
          return const Center(child: Text('Erro ao carregar os treinos'));
        }

        if (state is RequestCompletedState<List<WorkoutEntity>>) {
          final workouts = state.value!;

          if (workouts.isEmpty) {
            return const Center(child: Text('Nenhum treino encontrado.'));
          }

          return ListView.separated(
            itemCount: workouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteGeneratorHelper.kWorkoutDetails,
                  arguments: workout,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo: ${UtilEnum.getWorkoutTypeName(workout.type)}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}