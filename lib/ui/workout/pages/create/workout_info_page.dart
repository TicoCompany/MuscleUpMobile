import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/core/enum/workout/rokout_info_type_enum.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_factory_viewmodel.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';
import 'package:muscle_up_mobile/utils/util_enum.dart';

class WorkoutInfoPage extends StatelessWidget {
  final WorkoutCreateViewModel? viewModel;

  const WorkoutInfoPage({super.key, this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkoutCreateViewModel>(
      create: (_) => viewModel ?? WorkoutCreateFactoryViewModel().create(context),
      child: const _WorkoutInfoScreenBody(),
    );
  }
}

class _WorkoutInfoScreenBody extends StatefulWidget {
  const _WorkoutInfoScreenBody();

  @override
  State<_WorkoutInfoScreenBody> createState() => _WorkoutInfoScreenBodyState();
}

class _WorkoutInfoScreenBodyState extends State<_WorkoutInfoScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  workoutInfoTypeEnum? _selectedinfoType;
  WorkoutTypeEnum? _selectedType;

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedinfoType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final viewModel = context.read<WorkoutCreateViewModel>();
    viewModel.setWorkoutInfo(_nameController.text, _selectedinfoType!);

    Navigator.pushNamed(
      context,
      RouteGeneratorHelper.kWorkoutMuscles,
      arguments: viewModel,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Novo Treino',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Treino',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<workoutInfoTypeEnum>(
                decoration: InputDecoration(
                  labelText: 'Tipo de Treino',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                ),
                value: _selectedinfoType,
                items: workoutInfoTypeEnum.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(UtilEnum.getWorkoutInfoTypeName(e)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedinfoType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um tipo' : null,
              ),
             const SizedBox(height: 40), // Dá um respiro antes do botão
SafeArea(
  top: false,
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2F57),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: const Text(
        'Continuar',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
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
