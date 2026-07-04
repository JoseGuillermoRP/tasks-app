import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:lista_tarea/app/view/task_list/task_provider.dart';
import 'package:lista_tarea/app/view/components/h1.dart';
import 'package:lista_tarea/app/model/task.dart';

// Importamos nuestros widgets refactorizados para mantener esta vista limpia
import 'widgets/task_list_header.dart';
import 'widgets/new_task_modal.dart';
import 'widgets/edit_task_modal.dart';
import 'widgets/task_item.dart';

/// Pantalla principal de la lista de tareas.
/// Aquí inicializamos nuestro gestor de estado (TaskProvider) y envolvemos
/// toda la pantalla en un ShowCaseWidget para manejar el onboarding.
class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Creamos la instancia del provider y disparamos la carga inicial de tareas
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

// Usamos SingleTickerProviderStateMixin para poder sincronizar nuestra animación
// del botón flotante (FAB) con los frames de la pantalla (60fps/120fps).
class _TaskScreenState extends State<_TaskScreen> with SingleTickerProviderStateMixin {
  // Llaves necesarias para que el paquete Showcase identifique qué widgets resaltar
  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _taskKey = GlobalKey();

  // Controladores para la animación de "llamada a la acción" del botón de agregar
  late AnimationController _fabController;
  late Animation<Offset> _fabAnimation;

  @override
  void initState() {
    super.initState();

    // Configuramos la animación para que se repita infinitamente subiendo y bajando
    _fabController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);

    // Curva elasticOut para darle un efecto de "rebote" natural y llamativo
    _fabAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.3))
        .animate(CurvedAnimation(parent: _fabController, curve: Curves.elasticOut));

    // Esperamos a que la UI termine de renderizarse por primera vez antes de
    // evaluar si debemos mostrar el tutorial, de lo contrario daría error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          final provider = context.read<TaskProvider>();
          // Solo mostramos el tutorial si el usuario no lo ha completado y no tiene tareas
          if (!provider.isTutorialDone && provider.taskList.isEmpty) {
            ShowCaseWidget.of(context).startShowCase([_addKey]);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // Es vital liberar el controlador de animación para evitar fugas de memoria
    _fabController.dispose();
    super.dispose();
  }

  /// Abre el BottomSheet para crear una nueva tarea.
  void _showNewTaskModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el modal ocupe más espacio si aparece el teclado
      builder: (_) => ChangeNotifierProvider.value(
        // Pasamos la instancia actual del provider al modal para que pueda guardar la tarea
        value: context.read<TaskProvider>(),
        child: const NewTaskModal(),
      ),
    );

    // Verificamos si el widget sigue montado después de que el modal se cierra
    if (!mounted) return;

    final provider = context.read<TaskProvider>();
    // Si acaba de crear su primera tarea durante el tutorial, mostramos el segundo paso
    if (!provider.isTutorialDone && provider.taskList.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          ShowCaseWidget.of(context).startShowCase([_taskKey]);
          provider.completeTutorial(); // Marcamos el tutorial como finalizado
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
          // Pasamos la llave de la tarea al contenido de la lista para el segundo paso del tutorial
          Expanded(child: _TaskListContent(taskKey: _taskKey)),
        ],
      ),
      // Usamos un Consumer para escuchar el estado del tutorial.
      // Si el tutorial ya terminó, mostramos el botón estático. Si no, lo animamos.
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

/// Widget encargado de renderizar la lista de tareas y manejar el estado de vacío.
/// Se mantiene en este archivo ya que actúa como conector directo entre la vista principal,
/// el BottomSheet de edición y el Provider.
class _TaskListContent extends StatelessWidget {
  const _TaskListContent({Key? key, this.taskKey}) : super(key: key);
  final GlobalKey? taskKey;

  /// Muestra el modal para editar una tarea existente.
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
            // El Consumer escucha constantemente los cambios en la lista de tareas
            child: Consumer<TaskProvider>(
              builder: (_, provider, __) {
                // Estado vacío de la lista
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

                // Renderizamos la lista de manera eficiente con ListView.separated
                return ListView.separated(
                    itemCount: provider.taskList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      // Solo le pasamos la llave de Showcase al primer elemento de la lista
                      final isFirst = index == 0 && !provider.isTutorialDone;

                      return TaskItem(
                        provider.taskList[index],
                        showcaseKey: isFirst ? taskKey : null,
                        // Callbacks para comunicar la UI con las funciones del Provider
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