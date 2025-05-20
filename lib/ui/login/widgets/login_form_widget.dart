import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muscle_up_mobile/core/widgets/progress_indicator_widget.dart';
import 'package:muscle_up_mobile/domain/entities/core/request_state_entity.dart';
import 'package:muscle_up_mobile/ui/login/view_models/login_viewmodel.dart';
import 'package:muscle_up_mobile/utils/util_text.dart';
import 'package:muscle_up_mobile/utils/util_validator.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailTextController;
  late final TextEditingController _passwordTextController;
  late final LoginViewModel _loginViewModel;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _loginViewModel = context.read<LoginViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginViewModel, IRequestState<String>>(
      builder: (context, state) {
        final bool isProcessing = state is RequestProcessingState;
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !isProcessing,
                controller: _emailTextController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: UtilText.labelLoginYourEmail,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.person),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email.';
                  }
                  if (!UtilValidator.isValidEmail(value)) {
                    return 'Digite um email válido.';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  enabled: !isProcessing,
                  controller: _passwordTextController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: UtilText.labelLoginYourPassword,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.lock),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    if (!UtilValidator.isValidPassword(value)) {
                      return 'Digite uma senha válida.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                  onPressed: isProcessing ? null : onAuthentication,
                  child: !isProcessing
                      ? Text(UtilText.labelLoginTitle.toUpperCase())
                      : const ProgressIndicatorWidget(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onAuthentication() {
    if (_formKey.currentState?.validate() ?? false) {
      _loginViewModel.onAuthentication(
        _emailTextController.text,
        _passwordTextController.text,
      );
    }
  }
}
