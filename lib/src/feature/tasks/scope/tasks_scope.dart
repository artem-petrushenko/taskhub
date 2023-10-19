import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskhub/src/feature/tasks/bloc/tasks_bloc.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

abstract class TasksScope {
  static TasksBloc of(BuildContext context) {
    return context.read<TasksBloc>();
  }

  static void removeTask(BuildContext context, String taskId) {
    of(context).add(TasksEvent.removeTask(taskId: taskId));
  }

  static void updateReturnTask(BuildContext context, TaskModel task) {
    of(context).add(TasksEvent.updateReturnTask(task: task));
  }

  static void updateTask(BuildContext context, String taskId, bool value) {
    of(context).add(TasksEvent.updateTask(taskId: taskId, value: value));
  }

  static void fetchTasks(BuildContext context, String? taskId) {
    of(context).add(TasksEvent.fetchTasks(taskId: taskId));
  }

  static void addTask(BuildContext context, TaskModel task) {
    of(context).add(TasksEvent.addTask(task: task));
  }
}
