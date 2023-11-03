import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/editor/reducer/editor_reducer.dart';

abstract class EditorScope {
  static void removeTask(BuildContext context, String taskId) {
    StoreProvider.dispatch<EditorState>(
        context, RemoveTaskAction(taskId: taskId));
  }

  static void updateTask(BuildContext context, TaskModel task) {
    StoreProvider.dispatch<EditorState>(context, EditorTaskAction(task: task));
  }
}
