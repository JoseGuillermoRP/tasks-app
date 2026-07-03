import 'package:flutter/material.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/view/components/shape.dart';
import 'package:lista_tarea/app/view/task_list/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../model/task.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..fetchTasks(),
      child: ShowCaseWidget(
        builder: (context) => const _TaskScreen(),
      ),
    );
  }
}

class _TaskScreen extends StatefulWidget {
  const _TaskScreen({Key? key}) : super(key: key);

  @override
  State<_TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<_TaskScreen> {
  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _taskKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if(mounted){
          final provider = context.read<TaskProvider>();
          if (!provider.isTutorialDone && provider.taskList.isEmpty) {
            ShowCaseWidget.of(context).startShowCase([_addKey]);
          }
        }
      });
    });
  }

  void _showNewTaskModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: const _NewTaskModal(),
      ),
    );

    if(!mounted) return;
    final provider = context.read<TaskProvider>();

    if(!provider.isTutorialDone && provider.taskList.isNotEmpty){
      Future.delayed(const Duration(milliseconds: 600), () {
        if(mounted){
          ShowCaseWidget.of(context).startShowCase([_taskKey]);
          provider.completeTutorial();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          Expanded(child: _TaskList(taskKey: _taskKey)),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => Showcase(
          key: _addKey,
          title: '¡Empieza aquí!',
          description: 'Toca el botón para crear tu primera tarea 👆',
          tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Colors.white,
          targetShapeBorder: const CircleBorder(),
          disposeOnTap: true,
          onTargetClick: () {
            _showNewTaskModal(context);
          },
          child: FloatingActionButton(
            onPressed: () {
              _showNewTaskModal(context);
            },
            child: const Icon(Icons.add, size: 50),
          ),
        ),
      ),
    );
  }
}

class _NewTaskModal extends StatefulWidget {
  const _NewTaskModal({super.key});

  @override
  State<_NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<_NewTaskModal> {
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
  const _TaskList({Key? key, this.taskKey}) : super(key: key);
  final GlobalKey? taskKey;

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
                          'Tu lista está vacía',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 80),

                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemCount: provider.taskList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (_, index) {
                            final isFirst = index == 0 && !provider.isTutorialDone;
                            return _TaskITem(
                              provider.taskList[index],
                              showcaseKey: isFirst ? taskKey : null,
                              onTap: () => provider.onTaskDoneChange(provider.taskList[index]),
                              onDelete: () => provider.deleteTask(provider.taskList[index]),
                              onEdit: () => _editTask(context, provider.taskList[index]),
                            );
                          }
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
  const _TaskITem(this.task, {
    super.key,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.showcaseKey,
  });

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final GlobalKey? showcaseKey;

  @override
  Widget build(BuildContext context) {
    Widget itemContent = Dismissible(
      key: UniqueKey(),
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

    if (showcaseKey != null) {
      return Showcase(
        key: showcaseKey!,
        title: 'Gestos Mágicos ✨',
        description: 'Toca para cerrar esta luz y luego desliza tu tarea con el dedo ↔️',
        targetPadding: const EdgeInsets.all(4),
        tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
        disposeOnTap: true,
        onTargetClick: () {},
        child: itemContent,
      );
    }
    return itemContent;
  }
}