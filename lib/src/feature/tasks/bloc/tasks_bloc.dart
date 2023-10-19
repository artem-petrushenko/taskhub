import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:taskhub/src/common/model/task/task_model.dart';

import 'package:taskhub/src/common/data/repository/tasks/tasks_repository.dart';

part 'tasks_event.dart';

part 'tasks_state.dart';

part 'tasks_bloc.freezed.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _tasksRepository;

  TasksBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(const TasksState.loading()) {
    on<TasksEvent>(
      (event, emit) async => event.map<Future<void>>(
        fetchTasks: (event) => _onFetchTasks(event, emit),
        removeTask: (event) => _onRemoveTask(event, emit),
        updateTask: (event) => _onUpdateTask(event, emit),
        addTask: (event) => _onAddTask(event, emit),
        updateReturnTask: (event) => _updateReturnTask(event, emit),
      ),
      transformer: droppable(),
    );
  }

  Future<void> _onFetchTasks(
    _FetchTasks event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final tasks = await _tasksRepository.fetchTasks(
        uid: uid,
        taskId: event.taskId,
      );
      if (state is _Success) {
        if ((state as _Success).hasReachedMax) return;
        emit(
          tasks.isEmpty
              ? (state as _Success).copyWith(hasReachedMax: true)
              : (state as _Success).copyWith(
                  tasks: (state as _Success).tasks + tasks.toList(),
                  hasReachedMax: false,
                ),
        );
      } else {
        final newState = tasks.isEmpty
            ? const _Empty()
            : _Success(tasks: tasks.toList(), hasReachedMax: false);
        emit(newState);
      }
    } on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }

  Future<void> _onRemoveTask(
    _RemoveTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final taskId = event.taskId;
      await _tasksRepository.deleteTask(taskId: taskId);
      final updatedTasks = (state as _Success)
          .tasks
          .where((task) => task.taskId != taskId)
          .toList();

      if (updatedTasks.isEmpty) {
        emit(const _Empty());
      } else {
        emit((state as _Success).copyWith(tasks: updatedTasks));
      }
    } on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }

  Future<void> _onUpdateTask(
    _UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final updatedTasks = (state as _Success).tasks.map((task) {
        if (task.taskId == event.taskId) {
          return task.copyWith(completed: event.value);
        }
        return task;
      }).toList();

      await _tasksRepository.updateTask(
          task:
              updatedTasks.singleWhere((task) => task.taskId == event.taskId));
      emit((state as _Success).copyWith(tasks: updatedTasks));
    } on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }

  Future<void> _onAddTask(
    _AddTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      if (state is _Success) {
        List<TaskModel> list = List.from((state as _Success).tasks)
          ..add(event.task)
          ..sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) {
              return 0; // Both dates are null, consider them equal.
            } else if (a.dueDate == null) {
              return 1; // 'a' is null, so 'b' comes before 'a'.
            } else if (b.dueDate == null) {
              return -1; // 'b' is null, so 'a' comes before 'b'.
            } else {
              return a.dueDate!.compareTo(b.dueDate!); // Compare non-null dates.
            }
          });
        emit((state as _Success).copyWith(tasks: list));
      } else {
        emit(_Success(tasks: [event.task], hasReachedMax: true));
      }
    } on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }

  Future<void> _updateReturnTask(
    _UpdateReturnedTask event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final updatedTasks = (state as _Success).tasks.map((task) {
        if (task.taskId == event.task.taskId) {
          return task = event.task;
        }
        return task;
      }).toList();

      await _tasksRepository.updateTask(
          task:
          updatedTasks.singleWhere((task) => task.taskId == event.task.taskId));
      emit((state as _Success).copyWith(tasks: updatedTasks));
    } on Object catch (error) {
      emit(_Failure(error: error));
      rethrow;
    }
  }
}
