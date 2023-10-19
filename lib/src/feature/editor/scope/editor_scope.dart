import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskhub/src/feature/editor/bloc/editor_bloc.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

abstract class EditorScope {
  static EditorBloc of(BuildContext context) {
    return context.read<EditorBloc>();
  }

  static void removeTask(BuildContext context, String taskId) {
    of(context).add(EditorEvent.removeTask(taskId: taskId));
  }

  static void updateTask(BuildContext context, TaskModel task) {
    of(context).add(EditorEvent.updateTask(task: task));
  }
}
