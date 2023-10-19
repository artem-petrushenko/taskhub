import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';

part 'creator_event.dart';

part 'creator_state.dart';

part 'creator_bloc.freezed.dart';

class CreatorBloc extends Bloc<CreatorEvent, CreatorState> {
  final TasksRepository _tasksRepository;

  CreatorBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(const CreatorState.initial()) {
    on<CreatorEvent>(
      (event, emit) => event.map<Future<void>>(
        createTask: (event) => _onCreateTask(event, emit),
      ),
    );
  }

  Future<void> _onCreateTask(
    _CreateTask event,
    Emitter<CreatorState> emit,
  ) async {
    try {
      emit(const _Loading());
      final task = await _tasksRepository.createTask(task: event.task);
      emit(_Success(task: task));
    } on Object catch (error) {
      emit(_Failure(error: error));
      emit(const _Initial());
      rethrow;
    }
  }
}
