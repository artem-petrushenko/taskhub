import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/feature/creator/reducer/creator_reducer.dart';

abstract class CreatorScope {
  static void createTask(BuildContext context, TaskModel task) {
    StoreProvider.dispatch<CreatorState>(context, CreateTaskAction(task: task));
  }
}
