part of 'editor_bloc.dart';

@freezed
class EditorState with _$EditorState {
  const EditorState._();

  const factory EditorState.initial() = _Initial;

  const factory EditorState.loading() = _Loading;

  const factory EditorState.success({
    required final TaskModel task,
  }) = _Success;

  const factory EditorState.failure({
    required final Object error,
  }) = _Failure;
}
