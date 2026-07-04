import 'package:flutter/material.dart';
import 'package:lista_tarea/app/model/task.dart';
import 'package:showcaseview/showcaseview.dart';

/// Widget que representa un ítem individual en la lista de tareas.
/// Utiliza StatefulWidget para poder manejar sus propias animaciones internas
/// (la demostración del gesto Swipe) de forma independiente.
class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {
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
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> with SingleTickerProviderStateMixin {
  late AnimationController _demoController;
  late Animation<double> _demoAnimation;

  @override
  void initState() {
    super.initState();
    _demoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    // TweenSequence nos permite encadenar movimientos.
    // Esto crea un efecto fluido de vaivén: derecha -> izquierda -> vuelve al centro.
    // Incita al usuario a entender que este elemento es arrastrable.
    _demoAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 25.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 25.0, end: -25.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -25.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _demoController, curve: Curves.easeInOut));

    // Iniciamos la demostración solo si este elemento está siendo apuntado por el tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showcaseKey != null) {
        _demoController.repeat();

        // Detiene la animación automáticamente después de 6 segundos
        // para asegurar una buena UX y no saturar la pantalla con movimiento constante.
        Future.delayed(const Duration(seconds: 6), () {
          if (mounted && _demoController.isAnimating) {
            _demoController.stop();
            _demoController.reset();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant TaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la tarea fue actualizada desde el provider (ej. cambió de nombre o estado 'done'),
    // llamamos a setState para forzar al widget a redibujarse con los nuevos datos.
    // Esto es vital cuando convertimos widgets de lista a StateFulWidgets.
    if (oldWidget.task.title != widget.task.title || oldWidget.task.done != widget.task.done) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos nuestra lógica de arrastre (Dismissible) en la animación del tutorial
    Widget itemContent = AnimatedBuilder(
      animation: _demoAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_demoAnimation.value, 0),
        child: child,
      ),
      child: Dismissible(
        // IMPORTANTE: Al estar dentro de una lista dinámica, Dismissible DEBE usar
        // una llave atada a los datos reales (como el hashCode o un ID).
        // Si usáramos UniqueKey(), Flutter recrearía el widget perdiendo su estado actual.
        key: ValueKey(widget.task.hashCode),

        // Fondo que se revela al deslizar a la derecha
        background: Container(
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.edit, color: Colors.white)),

        // Fondo secundario que se revela al deslizar a la izquierda
        secondaryBackground: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_outline, color: Colors.white)),

        // Acciones al completar el arrastre
        onDismissed: (direction) => direction == DismissDirection.endToStart ? widget.onDelete?.call() : null,

        // confirmDismiss nos permite interceptar el gesto antes de que el widget se destruya.
        // Lo usamos para abrir el modal de edición en lugar de borrar el elemento.
        confirmDismiss: (direction) async {
          _demoController.stop(); // Detenemos animación si el usuario interactúa
          _demoController.reset();
          if (direction == DismissDirection.startToEnd) {
            widget.onEdit?.call();
            return false; // Retornamos false para que el widget regrese a su lugar (no se elimina)
          }
          return true; // Retornamos true para proceder a eliminarlo visualmente
        },
        child: GestureDetector(
          onTap: () {
            _demoController.stop();
            _demoController.reset();
            widget.onTap?.call(); // Marca la tarea como completada o pendiente
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(21),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
              child: Row(children: [
                Icon(
                    widget.task.done ? Icons.check_box_rounded : Icons.check_box_outline_blank,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                      widget.task.title,
                      style: TextStyle(
                          decoration: widget.task.done ? TextDecoration.lineThrough : null,
                          color: widget.task.done ? Colors.grey : null
                      ),
                    )),
              ]),
            ),
          ),
        ),
      ),
    );

    // Integramos Showcase solo si se nos pasó una llave, de lo contrario mostramos el contenido normal
    return widget.showcaseKey != null
        ? Showcase(
        key: widget.showcaseKey!,
        title: 'Gestos Mágicos ✨',
        description: 'Desliza para editar o borrar ↔️',
        child: itemContent)
        : itemContent;
  }
}