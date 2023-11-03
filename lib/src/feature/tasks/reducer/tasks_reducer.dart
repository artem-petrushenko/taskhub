import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskhub/src/common/model/task/task_model.dart';
import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';

part 'tasks_action.dart';

part 'tasks_state.dart';

part 'tasks_reducer.freezed.dart';

class TasksReducer {
  final TasksRepository _tasksRepository;

  TasksReducer({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository;

  Store<TasksState> createStore() => Store<TasksState>(
        initialState: const TasksState.loading(),
        environment: _tasksRepository,
      );
}
