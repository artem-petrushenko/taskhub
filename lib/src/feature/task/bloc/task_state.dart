part of 'task_bloc.dart';

@freezed
class TaskState with _$TaskState {
  const TaskState._();

  const factory TaskState.loading() = _Loading;

  const factory TaskState.success({
    required final TaskModel task,
  }) = _Success;

  const factory TaskState.failure({
    required final Object error,
  }) = _Failure;
}
