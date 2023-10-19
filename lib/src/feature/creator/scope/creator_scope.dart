import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/feature/creator/bloc/creator_bloc.dart';

abstract class CreatorScope {
  static CreatorBloc of(BuildContext context) {
    return context.read<CreatorBloc>();
  }

  static void removeTask(BuildContext context, TaskModel task) {
    of(context).add(CreatorEvent.createTask(task: task));
  }
}
