import 'package:async_redux/async_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';
import 'package:taskhub/src/common/model/task/task_model.dart';

part 'editor_action.dart';

part 'editor_state.dart';

part 'editor_reducer.freezed.dart';

class EditorReducer {
  final TasksRepository _tasksRepository;

  EditorReducer({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository;

  Store<EditorState> createStore() => Store<EditorState>(
    initialState: const EditorState.initial(),
    environment: _tasksRepository,
  );
}