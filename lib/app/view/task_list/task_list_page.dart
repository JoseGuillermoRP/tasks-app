import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lista_tarea/app/repository/task_repository.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/view/components/shape.dart';
import 'package:lista_tarea/app/view/task_list/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../model/task.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..fetchTasks(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            Expanded(child: _TaskList()),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showNewTaskModal(context),
            child: const Icon(Icons.add, size: 50),
          ),
        ),
      ),
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: _NewTaskModal(),
      ),
    );
  }
}


class _NewTaskModal extends StatefulWidget {
  const _NewTaskModal({super.key});

  @override
  State<_NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<_NewTaskModal>{
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
        child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              H1('Nueva Tarea'),
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
                child: Text('Guardar'),
              ),
            ],
          ),
        )

      ),
    );
  }
}






class _EditTaskModal extends StatefulWidget {
  const _EditTaskModal({super.key, required this.task});

  final Task task;

  @override
  State<_EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<_EditTaskModal> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
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

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  // Mueve el método aquí adentro
  void _editTask(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: _EditTaskModal(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1('Tareas'),
          const SizedBox(height: 13),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (_, provider, __) {
                if (provider.taskList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('👋', style: TextStyle(fontSize: 60)),
                        SizedBox(height: 16),
                        Text(
                          'Empecemos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Toca el botón + abajo\npara crear tu primera tarea.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 40),
                        Icon(
                          Icons.arrow_downward,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  children: [
                    if(!provider.isTutorialDone)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border:Border.all(color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('🎉 ¡Gran trabajo!', style: TextStyle(fontWeight:FontWeight.bold, fontSize:18)),
                            const SizedBox(height: 10),
                            const Text('👆 Toca el cuadro izquierdo para completarla.'),
                            const SizedBox(height: 6),
                            const Text('↔️ Desliza la tarea hacia los lados para Editar o Borrar.'),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: ()=> provider.completeTutorial(),
                                child: const Text('¡Entendido!'),
                              ),
                            )
                          ],
                        ),
                      ),
                Expanded(
                child: ListView.separated(
                itemCount: provider.taskList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) => _TaskITem(
                provider.taskList[index],
                onTap: () =>
                provider.onTaskDoneChange(provider.taskList[index]),
                onDelete: () =>
                provider.deleteTask(provider.taskList[index]),
                onEdit: () => _editTask(context, provider.taskList[index]),
                ),
                ),
                ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

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

class _TaskITem extends StatelessWidget {
  const _TaskITem(
    this.task, {
    super.key,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.title),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (onEdit != null) onEdit!();
          return false;
        } else {
          return true;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          if (onDelete != null) onDelete!();
        }
      },

      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),

      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
            child: Row(
              children: [
                Icon(
                  task.done
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.done ? TextDecoration.lineThrough : null,
                      color: task.done ? Colors.grey : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
