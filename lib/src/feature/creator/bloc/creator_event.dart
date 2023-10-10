part of 'creator_bloc.dart';

@freezed
class CreatorEvent with _$CreatorEvent {
  const CreatorEvent._();

  const factory CreatorEvent.createTask({
    required final TaskModel task,
  }) = _CreateTask;
}
