part of 'editor_reducer.dart';

class RemoveTaskAction extends ReduxAction<EditorState> {
  final String taskId;

  RemoveTaskAction({required this.taskId});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<EditorState> reduce() async {
    try {
      // return _Loading();
      await env.deleteTask(taskId: taskId);
      return _SuccessRemove(taskId: taskId);
    } on Object catch (error) {
      // return _Failure(error: error);
      return const _Initial();
    }
  }
}

class EditorTaskAction extends ReduxAction<EditorState> {
  final TaskModel task;

  EditorTaskAction({required this.task});

  @override
  TasksRepository get env => super.env as TasksRepository;

  @override
  Future<EditorState> reduce() async {
    try {
      // return const _Loading();
      await env.updateTask(task: task);
      return _SuccessUpdate(task: task);
    } on Object catch (error) {
      // return _Failure(error: error);
      return const _Initial();
    }
  }
}
