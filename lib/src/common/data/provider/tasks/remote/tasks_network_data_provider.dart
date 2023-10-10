import 'package:taskhub/src/common/model/task/task_model.dart';

abstract interface class TasksNetworkDataProvider {
  Future<Iterable<TaskModel>> fetchTasks({required String uid, String? taskId});

  Future<TaskModel> fetchTask({required String taskId});

  Future<String> createTask({required TaskModel task});

  Future<void> deleteTask({required String taskId});

  Future<void> updateTask({required TaskModel task});
}
