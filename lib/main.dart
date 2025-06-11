import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';
import 'package:muscle_up_mobile/configs/injection_conteiner.dart' as injector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injector.init(); // inicializa injeção de dependência
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muscle Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RouteGeneratorHelper.kHome,
      onGenerateRoute: RouteGeneratorHelper.generateRoute,
    );
  }
}
