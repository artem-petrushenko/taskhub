part of 'tasks_reducer.dart';

@freezed
class TasksState with _$TasksState {
  const TasksState._();

  const factory TasksState.loading() = _Loading;

  const factory TasksState.success({
    required final List<TaskModel> tasks,
    required final bool hasReachedMax,
  }) = _Success;

  const factory TasksState.empty() = _Empty;

  const factory TasksState.failure({
    required final Object error,
  }) = _Failure;
}
