import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';
import 'package:muscle_up_mobile/configs/injection_conteiner.dart' as injector;
import 'package:muscle_up_mobile/core/service/app_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injector.init(); // inicializa injeção de dependência
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = injector.getIt<IAppService>().navigatorKey;

    return MaterialApp(
      title: 'Muscle Up',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // 👈 ESSENCIAL PARA A NAVEGAÇÃO FUNCIONAR
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RouteGeneratorHelper.kLogin,
      onGenerateRoute: RouteGeneratorHelper.generateRoute,
    );
  }
}
