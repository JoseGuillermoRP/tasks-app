import 'package:flutter/material.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/view/task_list/task_provider.dart';
import 'package:lista_tarea/app/model/task.dart';
import 'package:provider/provider.dart';

/// Modal (BottomSheet) para editar una tarea existente.
/// Requiere la Tarea original para poder pre-poblar el campo de texto.
class EditTaskModal extends StatefulWidget {
  const EditTaskModal({super.key, required this.task});

  final Task task;

  @override
  State<EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Pre-llenamos el TextField con el título actual de la tarea a editar
    _controller = TextEditingController(text: widget.task.title);
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
              const H1('Editar Tarea'),
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
                    context.read<TaskProvider>().updateTask(
                      widget.task,
                      _controller.text,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}