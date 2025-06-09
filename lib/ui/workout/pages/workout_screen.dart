import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
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
      create: (_) =>
          WorkoutFactoryViewModel().create(context)..loadWorkouts(),
      child: const _WorkoutScreenBody(),
    );
  }
}

class _WorkoutScreenBody extends StatelessWidget {
  const _WorkoutScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                'Treinos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    'Meus Treinos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 24),
                  Text(
                    'Treinos Prontos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6A7091),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: _WorkoutListWidget(),
              ),
            ),
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
        if (state is RequestProcessingState ||
            state is RequestInitiationState) {
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
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteGeneratorHelper.kWorkoutDetails,
                  arguments: workout,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        workout.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 18),
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
