part of 'tasks_bloc.dart';

@freezed
class TasksEvent with _$TasksEvent {
  const TasksEvent._();

  const factory TasksEvent.fetchTasks({
    final String? taskId,
  }) = _FetchTasks;

  const factory TasksEvent.removeTask({
    required final String taskId,
  }) = _RemoveTask;

  const factory TasksEvent.addTask({
    required final TaskModel task,
  }) = _AddTask;

  const factory TasksEvent.updateTask({
    required final String taskId,
    required final bool value,
  }) = _UpdateTask;
}
