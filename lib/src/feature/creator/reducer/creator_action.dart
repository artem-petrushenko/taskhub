part of 'creator_reducer.dart';

class CreateTaskAction extends ReduxAction<CreatorState> {
  final TaskModel task;

  CreateTaskAction({required this.task});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<CreatorState> reduce() async {
    try {
      // return const _Loading();
      final currentTask = await env.createTask(task: task);
      return _Success(task: currentTask);
    } on Object catch (error) {
      // return _Failure(error: error);
      return const _Initial();
    }
  }
}
