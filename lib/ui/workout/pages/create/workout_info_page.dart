import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/core/enum/workout/workout_type_enum.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_viewmodel.dart';
import 'package:muscle_up_mobile/ui/workout/viewmodels/workout_create_factory_viewmodel.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

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
  WorkoutTypeEnum? _selectedType;

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final viewModel = context.read<WorkoutCreateViewModel>();
    viewModel.setWorkoutInfo(_nameController.text, _selectedType!);

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
      appBar: AppBar(title: const Text('Novo Treino')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Treino'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<WorkoutTypeEnum>(
                decoration: const InputDecoration(labelText: 'Tipo de Treino'),
                value: _selectedType,
                items: WorkoutTypeEnum.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um tipo' : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
