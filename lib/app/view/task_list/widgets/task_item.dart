import 'package:flutter/material.dart';
import 'package:lista_tarea/app/model/task.dart';
import 'package:showcaseview/showcaseview.dart';

/// Widget que representa un ítem individual en la lista de tareas.
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

    _demoAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 25.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 25.0, end: -25.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -25.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _demoController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showcaseKey != null) {
        _demoController.repeat();

        // Detiene la animación de demo después de 6 segundos para no saturar la UX
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
    Widget itemContent = AnimatedBuilder(
      animation: _demoAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_demoAnimation.value, 0),
        child: child,
      ),
      child: Dismissible(
        key: ValueKey(widget.task.hashCode),
        background: Container(
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.edit, color: Colors.white)),
        secondaryBackground: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_outline, color: Colors.white)),
        onDismissed: (direction) => direction == DismissDirection.endToStart ? widget.onDelete?.call() : null,
        confirmDismiss: (direction) async {
          _demoController.stop();
          _demoController.reset();
          if (direction == DismissDirection.startToEnd) {
            widget.onEdit?.call();
            return false;
          }
          return true;
        },
        child: GestureDetector(
          onTap: () {
            _demoController.stop();
            _demoController.reset();
            widget.onTap?.call();
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

    return widget.showcaseKey != null
        ? Showcase(
        key: widget.showcaseKey!,
        title: 'Gestos Mágicos ✨',
        description: 'Desliza para editar o borrar ↔️',
        child: itemContent,
    )
        : itemContent;
  }
}