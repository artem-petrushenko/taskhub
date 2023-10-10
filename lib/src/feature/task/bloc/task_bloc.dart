import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';

part 'task_event.dart';

part 'task_state.dart';

part 'task_bloc.freezed.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TasksRepository _tasksRepository;

  TaskBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(const TaskState.loading()) {
    on<TaskEvent>(
      (event, emit) => event.map<Future<void>>(
        fetchTask: (event) => _onFetchTask(event, emit),
      ),
    );
  }

  Future<void> _onFetchTask(_FetchTask event, Emitter<TaskState> emit) async {
    try {
      emit(const _Loading());
      final task = await _tasksRepository.fetchTask(taskId: event.taskId);
      emit(_Success(task: task));
    } on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }
}
