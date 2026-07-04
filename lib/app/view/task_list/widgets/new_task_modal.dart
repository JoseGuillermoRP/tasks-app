import 'package:flutter/material.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/view/task_list/task_provider.dart';
import 'package:lista_tarea/app/model/task.dart';
import 'package:provider/provider.dart';

/// Modal para la creación de nuevas tareas.
class NewTaskModal extends StatefulWidget {
  const NewTaskModal({super.key});

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 23),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const H1('Nueva Tarea'),
              const SizedBox(height: 26),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: 'Descripción de la tarea',
                ),
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    final task = Task(_controller.text);
                    context.read<TaskProvider>().addNewTask(task);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}