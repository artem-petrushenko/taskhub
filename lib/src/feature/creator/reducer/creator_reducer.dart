import 'package:async_redux/async_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';
import 'package:taskhub/src/common/model/task/task_model.dart';

part 'creator_action.dart';

part 'creator_state.dart';

part 'creator_reducer.freezed.dart';

class CreatorReducer {
  final TasksRepository _tasksRepository;

  CreatorReducer({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository;

  Store<CreatorState> createStore() => Store<CreatorState>(
        initialState: const CreatorState.initial(),
        environment: _tasksRepository,
      );
}
