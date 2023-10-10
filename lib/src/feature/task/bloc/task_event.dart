part of 'task_bloc.dart';

@freezed
class TaskEvent with _$TaskEvent {
  const TaskEvent._();

  const factory TaskEvent.fetchTask({
    required final String taskId,
  }) = _FetchTask;
}
