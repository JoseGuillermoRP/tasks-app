import 'package:flutter/material.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/view/components/shape.dart';
import 'package:lista_tarea/app/view/task_list/task_list_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // 1. Definimos el tiempo de espera (ej. 2.5 segundos) para que el usuario lea el mensaje
    await Future.delayed(const Duration(milliseconds: 2500));

    // 2. Validación de seguridad: Verificamos que el widget siga en pantalla antes de navegar
    if (!mounted) return;

    // 3. Navegación Senior: Usamos pushReplacement para destruir el Splash Screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TaskListPage(), // Asegúrate de que el nombre de tu clase sea este
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Row(
            children: [
              Shape(), // Tu figura verde superior
            ],
          ),
          const SizedBox(height: 79),
          Image.asset(
            'assets/image/onboarding-image.png',
            width: 180,
            height: 168,
          ),
          const SizedBox(height: 99),
          const H1('Lista de Tareas'),
          const SizedBox(height: 21),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'La mejor forma para que no se te olvide nada es anotarlo. Guarda tus tareas y ve completándolas poco a poco para aumentar tu productividad.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}