import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/domain/entities/workout/workout_entity.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_viewmodel.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_factory_viewmodel.dart';
import 'package:muscle_up_mobile/utils/util_enum.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Inicializa o TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Desfaz o TabController quando o widget for destruído
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutViewModel>(
      create: (_) => WorkoutFactoryViewModel().create(context)..loadWorkouts(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: const Text('Treinos', style: TextStyle(color: Colors.black)),
          bottom: TabBar(
            controller: _tabController, // Passando o TabController aqui
            labelColor: const Color(0xFF6A7091),
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color(0xFF6A7091),
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Meus Treinos'),
              Tab(text: 'Treinos Prontos'),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFFAF7FF), // fundo claro suave
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController, // Passando o TabController aqui também
                  children: [
                    const _WorkoutListWidget(),
                    const Center(child: Text("Em breve")), // segunda aba placeholder
                  ],
                ),
              ),
             SafeArea(
  top: false,
  child: Padding(
    padding: const EdgeInsets.only(bottom: 12), // eleva o botão
    child: ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          RouteGeneratorHelper.kWorkoutInfo,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A7091),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: const Text(
        'Criar Novo Treino',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutListWidget extends StatelessWidget {
  const _WorkoutListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutViewModel, IRequestState<List<WorkoutEntity>>>(builder: (context, state) {
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 249, 249, 250),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      size: 24,
                      color: Color(0xFF6A7091),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tipo: ${UtilEnum.getWorkoutInfoTypeName(workout.type)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      return const SizedBox.shrink();
    });
  }
}
