import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/configs/assets_helper.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco liso
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título do topo
            Padding(
  padding: const EdgeInsets.only(top: 32.0),
  child: Center(
    child: Image.asset(
      AssetsHelper.kBanner,
      height: 100, // ajuste o tamanho conforme necessário
      fit: BoxFit.contain,
    ),
  ),
),


            // Texto de boas-vindas + botão
            Padding(
              padding: const EdgeInsets.only(bottom: 350),
              child: Column(
                children: [
                  Text(
                    'Bem-vindo ao MuscleUp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteGeneratorHelper.kWorkouts,
                      );
                    },
                    icon: Icon(Icons.fitness_center, size: 18),
                    label: Text('Ver Treinos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2C2F57),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
