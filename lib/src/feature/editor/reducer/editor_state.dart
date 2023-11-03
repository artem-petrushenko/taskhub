part of 'editor_reducer.dart';

@freezed
class EditorState with _$EditorState {
  const EditorState._();

  const factory EditorState.initial() = _Initial;

  const factory EditorState.loading() = _Loading;

  const factory EditorState.successUpdate({
    required final TaskModel task,
  }) = _SuccessUpdate;

  const factory EditorState.successRemove({
    required final String taskId,
  }) = _SuccessRemove;

  const factory EditorState.failure({
    required final Object error,
  }) = _Failure;
}
