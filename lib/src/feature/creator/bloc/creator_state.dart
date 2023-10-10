part of 'creator_bloc.dart';

@freezed
class CreatorState with _$CreatorState {
  const CreatorState._();

  const factory CreatorState.initial() = _Initial;

  const factory CreatorState.loading() = _Loading;

  const factory CreatorState.success({
    required final TaskModel task,
  }) = _Success;

  const factory CreatorState.failure({
    required final Object error,
  }) = _Failure;
}
