import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/tasks/reducer/tasks_reducer.dart';

abstract class TasksScope {
  static void removeTask(BuildContext context, String taskId) {
    StoreProvider.dispatch<TasksState>(context, RemoveTaskAction(taskId: taskId));
  }

  static void updateReturnTask(BuildContext context, TaskModel task) {
    StoreProvider.dispatch<TasksState>(context, UpdateReturnedTaskAction(task: task));
  }

  static void updateTask(BuildContext context, String taskId, bool value) {
    StoreProvider.dispatch<TasksState>(context, UpdateTaskAction(taskId: taskId, value: value));
  }

  static void fetchTasks(BuildContext context, String? taskId) {
    StoreProvider.dispatch<TasksState>(context, FetchTasksAction(taskId: taskId));
  }

  static void addTask(BuildContext context, TaskModel task) {
    StoreProvider.dispatch<TasksState>(context, AddTaskAction(task: task));
  }
}
