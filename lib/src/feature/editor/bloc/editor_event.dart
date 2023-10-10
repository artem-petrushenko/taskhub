part of 'editor_bloc.dart';

@freezed
class EditorEvent with _$EditorEvent {
  const EditorEvent._();

  const factory EditorEvent.removeTask({
    required final String taskId,
  }) = _RemoveTask;

  const factory EditorEvent.updateTask({
    required final TaskModel task,
  }) = _UpdateTask;
}
