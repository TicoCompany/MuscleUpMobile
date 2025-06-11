import 'package:flutter/material.dart';
import 'package:muscle_up_mobile/routing/route_generator.dart';
import 'package:muscle_up_mobile/configs/assets_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF7FF), // fundo claro suave
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(AssetsHelper.kIcone, height: 50),
        // Substitua com a logo depois
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo (substitua o asset para a imagem correta)
              Image.asset(AssetsHelper.kBanner, height: 150),
              const SizedBox(height: 350),
              // Botão estilizado para navegar até os treinos
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteGeneratorHelper
                        .kInitial, // Navegar para a tela de treinos
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A7091), // cor do botão
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Meus Treinos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
