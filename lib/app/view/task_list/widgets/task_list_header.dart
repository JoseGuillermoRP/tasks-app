import 'package:flutter/material.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/view/components/shape.dart';

class TaskListHeader extends StatelessWidget {
  const TaskListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Row(children: const [Shape()]),
          Column(
            children: [
              Image.asset(
                'assets/image/tasks-list-image.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 13),
              const H1('Completa tus tareas', color: Colors.white),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}