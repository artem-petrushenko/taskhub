import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

part 'editor_event.dart';

part 'editor_state.dart';

part 'editor_bloc.freezed.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  final TasksRepository _tasksRepository;

  EditorBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(const EditorState.initial()) {
    on<EditorEvent>(
      (event, emit) => event.map<Future<void>>(
        removeTask: (event) => _onRemoveTask(event, emit),
        updateTask: (event) => _onUpdateTask(event, emit),
      ),
    );
  }

  Future<void> _onUpdateTask(
    EditorEvent event,
    Emitter<EditorState> emit,
  ) async {
    try {} on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }

  Future<void> _onRemoveTask(
    _RemoveTask event,
    Emitter<EditorState> emit,
  ) async {
    try {} on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }
}
