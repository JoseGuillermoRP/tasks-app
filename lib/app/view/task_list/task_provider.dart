import 'package:flutter/foundation.dart';
import 'package:lista_tarea/app/repository/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];

  final TaskRepository _taskRepository = TaskRepository();

  bool _isTutorialDone = false;
  bool get isTutorialDone => _isTutorialDone;

  Future<void> fetchTasks() async {
    _taskList = await _taskRepository.getTasks();

    final prefs = await SharedPreferences.getInstance();
    _isTutorialDone = prefs.getBool('tutorial_done')?? false;

    notifyListeners();
  }

  Future<void> completeTutorial() async{
    _isTutorialDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_done',true);
    notifyListeners();
  }



  List<Task> get taskList => _taskList;

  void onTaskDoneChange(Task task) {
    task.done = !task.done;
    _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  void addNewTask(Task task) {
    _taskRepository.addTask(task);
    fetchTasks();
  }

  void deleteTask(Task task) {
    _taskList.remove(task);
    _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  void updateTask(Task task, String newTitle) {
    task.title = newTitle;
    _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }
}
