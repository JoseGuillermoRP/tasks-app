import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:lista_tarea/app/view/task_list/task_provider.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/model/task.dart';

import 'widgets/task_list_header.dart';
import 'widgets/new_task_modal.dart';
import 'widgets/edit_task_modal.dart';
import 'widgets/task_item.dart';

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

class _TaskScreenState extends State<_TaskScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _taskKey = GlobalKey();

  late AnimationController _fabController;
  late Animation<Offset> _fabAnimation;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);

    _fabAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.3))
        .animate(CurvedAnimation(parent: _fabController, curve: Curves.elasticOut));

    // Esperamos al renderizado y agregamos un delay para evitar excepciones con ShowcaseView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          final provider = context.read<TaskProvider>();
          if (!provider.isTutorialDone && provider.taskList.isEmpty) {
            ShowCaseWidget.of(context).startShowCase([_addKey]);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _showNewTaskModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: const NewTaskModal(),
      ),
    );

    if (!mounted) return;

    final provider = context.read<TaskProvider>();
    // Si el usuario crea su primera tarea en el tutorial, se activa el segundo paso automáticamente
    if (!provider.isTutorialDone && provider.taskList.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
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
          const TaskListHeader(),
          Expanded(child: _TaskListContent(taskKey: _taskKey)),
        ],
      ),
      floatingActionButton: Consumer<TaskProvider>(
        builder: (context, provider, child) => provider.isTutorialDone
            ? child!
            : SlideTransition(position: _fabAnimation, child: child),
        child: Showcase(
          key: _addKey,
          title: '¡Empieza aquí!',
          description: '¡Toca este botón para crear tu primera tarea!',
          child: FloatingActionButton(
            onPressed: () => _showNewTaskModal(context),
            child: const Icon(Icons.add, size: 50),
          ),
        ),
      ),
    );
  }
}

class _TaskListContent extends StatelessWidget {
  const _TaskListContent({Key? key, this.taskKey}) : super(key: key);
  final GlobalKey? taskKey;

  void _editTask(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: EditTaskModal(task: task),
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
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                    itemCount: provider.taskList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final isFirst = index == 0 && !provider.isTutorialDone;

                      return TaskItem(
                        provider.taskList[index],
                        showcaseKey: isFirst ? taskKey : null,
                        onTap: () => provider.onTaskDoneChange(provider.taskList[index]),
                        onDelete: () => provider.deleteTask(provider.taskList[index]),
                        onEdit: () => _editTask(context, provider.taskList[index]),
                      );
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}